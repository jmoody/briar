#include Briar::Email
#include Briar::Core

Then /^I should see email body that contains "([^"]*)"$/ do |text|
  wait_for_animation
  unless email_body_first_line_is? text
    screenshot_and_raise "i did not see an email body (MFComposeTextContentView) containing '#{text}'"
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
    screenshot_and_raise "expected to see '#{text}' in 'subjectField' but found '#{actual.first}'"
  end
end

Then /^I should see email view with to field set to "([^"]*)"$/ do |text|
  should_see_mail_view
  wait_for_animation

  unless email_to_field_is? text
    screenshot_and_raise "expected to see '#{text}' in 'subjectField' but found '#{actual.first}'"
  end
end

Then /^I should see email view with text like "([^"]*)" in the subject$/ do |text|
  should_see_mail_view
  wait_for_animation

  unless email_subject_has_text_like? text
    actual = query("view marked:'subjectField'", :text)
    screenshot_and_raise "expected to see '#{text}' in 'subjectField' but found '#{actual.first}'"
  end
end

When /^I cancel email editing I should see the "([^"]*)" view$/ do |view_id|
  should_see_mail_view
  wait_for_animation

  if gestalt.is_ios6?
    puts "WARN: iOS6 detected - navbar cancel button is not visible on iOS 6"
  else
    touch_navbar_item "Cancel"
    wait_for_animation
    touch_transition("button marked:'Delete Draft'",
                     "view marked:'#{view_id}'",
                     {:timeout=>TOUCH_TRANSITION_TIMEOUT,
                      :retry_frequency=>TOUCH_TRANSsITION_RETRY_FREQ})
  end
end
