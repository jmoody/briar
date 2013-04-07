
#noinspection RubyUnusedLocalVariable
Then /^I should see email body that contains "([^"]*)"$/ do |text|
  pending "deprecated 0.0.6 - use 'Then I should see email view with body that contains \"#{text}\"'"
end

Then /^I should see email view with body that contains "([^"]*)"$/ do |text|
  if gestalt.is_ios6?
    puts 'WARN: iOS6 detected - cannot test for email views on iOS simulator or devices'
  else
    wait_for_animation
    unless email_body_contains? text
      screenshot_and_raise "expected to see email body containing '#{text} but found '#{email_body}'"
    end
  end
end

Then /^I touch the "([^"]*)" row and wait to see the email view$/ do |row_id|
  should_see_row row_id
  touch("tableViewCell marked:'#{row_id}'")
  wait_for_animation
  if gestalt.is_ios6?
    puts 'WARN: iOS6 detected - cannot test for email views on iOS simulator or devices'
  else
    should_see_mail_view
  end
end

Then /^I should see email view with "([^"]*)" in the subject$/ do |text|
  if gestalt.is_ios6?
    puts 'WARN: iOS6 detected - cannot test for email views on iOS simulator or devices'
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
    puts 'WARN: iOS6 detected - cannot test for email views on iOS simulator or devices'
  else
    should_see_mail_view
    wait_for_animation
    addrs = comma_sep_addrs.split(/, ?/)
    addrs.each do |expected|
      unless email_to_contains? expected.strip
        screenshot_and_raise "expected to see '#{expected}' in the email 'to' field but found '#{email_to}'"
      end
    end
  end
end

#noinspection RubyUnusedLocalVariable
Then /^I should see email view with to field set to "([^"]*)"$/ do |text|
  pending "deprecated 0.0.6 - use 'Then I should see email view with recipients \"#{text}\"'"
end

Then /^I should see email view with text like "([^"]*)" in the subject$/ do |text|
  if gestalt.is_ios6?
    puts 'WARN: iOS6 detected - cannot test for email views on iOS simulator or devices'
  else
    should_see_mail_view
    wait_for_animation
    unless email_subject_has_text_like? text
      screenshot_and_raise "expected to see '#{text}' in the email subject but found '#{email_subject}'"
    end
  end
end

When /^I cancel email editing I should see the "([^"]*)" view$/ do |view_id|
  if gestalt.is_ios6?
    puts 'WARN: iOS6 detected - cannot test for email views on iOS simulator or devices'
  else
    should_see_mail_view
    wait_for_animation
    touch_navbar_item 'Cancel'
    wait_for_animation
    touch_transition("button marked:'Delete Draft'",
                     "view marked:'#{view_id}'",
                     {:timeout=>TOUCH_TRANSITION_TIMEOUT,
                      :retry_frequency=>TOUCH_TRANSITION_RETRY_FREQ})
  end
end

When(/^we are testing on the simulator or a device configured to send emails$/) do
  # motivation:  the simulator can always present the compose mail dialog, but
  #              devices with no email accounts active/configured will display
  #              a system-level alert when MFMailComposeViewController alloc] init]
  #              is called.
  # todo: figure out how to deal with system-level no-email-configured alert
  if gestalt.is_device?
    configured_for_mail_sel = 'calabash_backdoor_configured_for_mail:'
    res = backdoor(configured_for_mail_sel, 'ignorable')
    unless res.eql? 'YES'
      pending 'device is not configured to send email - we cannot proceed with email view testing'
    end
  end
end
