
#noinspection RubyUnusedLocalVariable
Then /^I should see email body that contains "([^"]*)"$/ do |text|
  pending "deprecated 0.0.6 - use 'Then I should see email view with body that contains \"#{text}\"'"
end

Then /^I should see email view with body that contains "([^"]*)"$/ do |text|
  if not device.ios5?
    warn_about_no_ios5_email_view
  else
    2.times { step_pause }
    unless email_body_contains? text
      screenshot_and_raise "expected to see email body containing '#{text} but found '#{email_body}'"
    end
  end
end

Then /^I touch the "([^"]*)" row and wait to see the email view$/ do |row_id|
  if email_not_testable?
    warn_about_no_ios5_email_view
    return
  end

  if device_can_send_email
    should_see_row row_id
    briar_scroll_to_row_and_touch row_id
    2.times { step_pause }
    should_see_mail_view
  else
    pending 'device is not configured for email so a system alert is probably generated'
  end
end

Then /^I should see email view with "([^"]*)" in the subject$/ do |text|
  if not device.ios5?
    warn_about_no_ios5_email_view
  else
    wait_for_animation
    should_see_mail_view
    unless email_subject_is? text
      screenshot_and_raise "expected to see '#{text}' in the email subject but found '#{email_subject}'"
    end
  end
end

Then /^I should see email view with recipients? "([^"]*)"$/ do |comma_sep_addrs|
  if not device.ios5?
    warn_about_no_ios5_email_view
  else
    should_see_recipients comma_sep_addrs
  end
end

#noinspection RubyUnusedLocalVariable
Then /^I should see email view with to field set to "([^"]*)"$/ do |text|
  pending "deprecated 0.0.6 - use 'Then I should see email view with recipients \"#{text}\"'"
end

Then /^I should see email view with text like "([^"]*)" in the subject$/ do |text|
  if not device.ios5?
    warn_about_no_ios5_email_view
  else
    should_see_mail_view
    2.times { step_pause }
    unless email_subject_has_text_like? text
      screenshot_and_raise "expected to see '#{text}' in the email subject but found '#{email_subject}'"
    end
  end
end

When /^I cancel email editing I should see the "([^"]*)" view$/ do |view_id|
  delete_draft_and_wait_for view_id
end

Given(/^we are testing on the simulator or a device configured to send emails$/) do
  # motivation:  the simulator can always present the compose mail dialog, but
  #              devices with no email accounts active/configured will display
  #              a system-level alert when MFMailComposeViewController alloc] init]
  #              is called.
  # todo: figure out how to deal with system-level no-email-configured alert
  unless device_can_send_email
    pending 'device is not configured to send email - we cannot proceed with email view testing'
  end
end
