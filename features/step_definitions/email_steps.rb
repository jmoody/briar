
#noinspection RubyUnusedLocalVariable
Then /^I should see email body that contains "([^"]*)"$/ do |text|
  pending 'deprecated 0.0.6 - use I should see email view with body that contains'
end

Then /^I should see email view with body that contains "([^"]*)"$/ do |text|
  wait_for_animation
  unless email_body_contains? text
    screenshot_and_raise "expected to see email body containing '#{text} but found '#{email_body}'"
  end
end

Then /^I touch the "([^"]*)" row and wait to see the email view$/ do |row_id|
  should_see_row row_id
  touch("tableViewCell marked:'#{row_id}'")
  wait_for_animation
  should_see_mail_view
end

Then /^I should see email view with "([^"]*)" in the subject$/ do |text|
  wait_for_animation
  should_see_mail_view
  unless email_subject_is? text
    screenshot_and_raise "expected to see '#{text}' in the email subject but found '#{email_subject}'"
  end
end

Then /^I should see email view with recipients "([^"]*)"$/ do |comma_sep_addrs|
  should_see_mail_view
  wait_for_animation
  addrs = comma_sep_addrs.split(/, ?/)
  addrs.each do |expected|
    unless email_to_contains? expected.strip
      screenshot_and_raise "expected to see '#{expected}' in the email 'to' field but found '#{email_to}'"
    end
  end
end

#noinspection RubyUnusedLocalVariable
Then /^I should see email view with to field set to "([^"]*)"$/ do |text|
  pending 'deprecated 0.0.5 - use I should see email with recipients'
end

Then /^I should see email view with text like "([^"]*)" in the subject$/ do |text|
  should_see_mail_view
  wait_for_animation
  unless email_subject_has_text_like? text
    screenshot_and_raise "expected to see '#{text}' in the email subject but found '#{email_subject}'"
  end
end

When /^I cancel email editing I should see the "([^"]*)" view$/ do |view_id|
  should_see_mail_view
  wait_for_animation

  if gestalt.is_ios6?
    puts 'WARN: iOS6 detected - navbar cancel button is not visible on iOS 6'
  else
    touch_navbar_item 'Cancel'
    wait_for_animation
    touch_transition("button marked:'Delete Draft'",
                     "view marked:'#{view_id}'",
                     {:timeout=>TOUCH_TRANSITION_TIMEOUT,
                      :retry_frequency=>TOUCH_TRANSITION_RETRY_FREQ})
  end
end
