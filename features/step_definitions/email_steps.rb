include Briar::Email
include Briar::Core

Then /^I should see email body that contains "([^"]*)"$/ do |text|
  wait_for_animation
  if is_ios5_mail_view
    puts "is iOS 5 simulator or device"
    unless email_body_contains_text text
      screenshot_and_raise "i did not see an email body (MFComposeTextContentView) containing '#{text}'"
    end
  else
    puts "cannot test for email body iOS 6 simulator or device"
    true
  end
end

Then /^I touch the "([^"]*)" row and wait to see the email view$/ do |row_id|
  should_see_row row_id
  touch("tableViewCell marked:'#{row_id}'")
  wait_for_animation
  is_ios5_mail_view || is_ios6_mail_view
end

Then /^I should see email view with "([^"]*)" in the subject$/ do |text|
  wait_for_animation
  should_see_mail_view
  if is_ios5_mail_view
    actual = query("view marked:'subjectField'", :text)
    unless actual.length == 1 && actual.first.eql?(text)
      screenshot_and_raise "expected to see '#{text}' in 'subjectField' but found '#{actual.first}'"
    end
  else
    puts "cannot test for email subject field on iOS simulator or devices"
    true
  end
end

Then /^I should see email view with to field set to "([^"]*)"$/ do |text|
  should_see_mail_view
  wait_for_animation
  if is_ios5_mail_view
    actual = query("view marked:'toField'", :text)
    unless actual.length == 1 && actual.first.eql?(text)
      screenshot_and_raise "expected to see '#{text}' in 'subjectField' but found '#{actual.first}'"
    end
  else
    puts "cannot test for email subject field on iOS simulator or devices"
    true
  end
end

Then /^I should see email view with text like "([^"]*)" in the subject$/ do |text|
  should_see_mail_view
  wait_for_animation
  if is_ios5_mail_view
    res = query("view marked:'subjectField' {text LIKE '*#{text}*'}").empty?
    if res
      actual = query("view marked:'subjectField'", :text)
      screenshot_and_raise "expected to see '#{text}' in 'subjectField' but found '#{actual.first}'"
    end
  else
    puts "cannot test for email subject field on iOS simulator or devices"
    true
  end
end

When /^I cancel email editing I should see the "([^"]*)" view$/ do |view_id|
  should_see_mail_view
  wait_for_animation
  if is_ios5_mail_view
    touch_navbar_item "Cancel"
    wait_for_animation
    touch_transition("button marked:'Delete Draft'",
                     "view marked:'#{view_id}'",
                     {:timeout=>TOUCH_TRANSITION_TIMEOUT,
                      :retry_frequency=>TOUCH_TRANSsITION_RETRY_FREQ})
  else
    puts "nothing to do - cancel button is not visible on iOS 6"
    true
  end
end
