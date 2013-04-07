
#noinspection RubyUnusedLocalVariable
Then /^I should see email body that contains "([^"]*)"$/ do |text|
  pending "deprecated 0.0.6 - use 'Then I should see email view with body that contains \"#{text}\"'"
end

Then /^I should see email view with body that contains "([^"]*)"$/ do |text|
  if gestalt.is_ios6?
    warn_about_ios6_email_view
    puts 'WARN: iOS6 detected - cannot test for email views on iOS simulator or devices'
  else
    wait_for_animation
    unless email_body_contains? text
      screenshot_and_raise "expected to see email body containing '#{text} but found '#{email_body}'"
    end
  end
end

Then /^I touch the "([^"]*)" row and wait to see the email view$/ do |row_id|
  if device_can_send_email
    # cannot do the usual - touch_row_and_wait_to_see because sometimes
    # we will not see because in iOS 6, email compose views cannot be queried
    # by calabash
    should_see_row row_id
    touch("tableViewCell marked:'#{row_id}'")
    wait_for_animation
    if gestalt.is_ios6?
      warn_about_ios6_email_view
    else
      should_see_mail_view
    end
  else
    pending 'device is not configured for email so a system alert is probably generated, which we cannot touch'
  end
end

Then /^I should see email view with "([^"]*)" in the subject$/ do |text|
  if gestalt.is_ios6?
    warn_about_ios6_email_view
  else
    wait_for_animation
    should_see_mail_view
    unless email_subject_is? text
      screenshot_and_raise "expected to see '#{text}' in the email subject but found '#{email_subject}'"
    end
  end
end

Then /^I should see email view with recipients? "([^"]*)"$/ do |comma_sep_addrs|
  if gestalt.is_ios6?
    warn_about_ios6_email_view
  else
    should_see_recipients comma_sep_addrs
  end
end

#noinspection RubyUnusedLocalVariable
Then /^I should see email view with to field set to "([^"]*)"$/ do |text|
  pending "deprecated 0.0.6 - use 'Then I should see email view with recipients \"#{text}\"'"
end

Then /^I should see email view with text like "([^"]*)" in the subject$/ do |text|
  if gestalt.is_ios6?
    warn_about_ios6_email_view
  else
    should_see_mail_view
    wait_for_animation
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
