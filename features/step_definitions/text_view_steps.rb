Then /^I clear (?:text|the text) view named "([^\"]*)"$/ do |name|
  wait_for_query "textView marked:'#{name}'"
  briar_clear_text(name)
end

Then /^I should not see "([^"]*)" text view$/ do |name|
  should_not_see_text_view (name)
end

Then /^I should see the text I just entered in the "([^"]*)" text view$/ do |text_view_id|
  should_see_text_view_with_text text_view_id, @text_entered_by_keyboard
end

Then /^I should see text view "([^"]*)" with placeholder text "([^"]*)"$/ do |text_view, placeholder|
  tv_exists = !query("textView marked:'#{text_view}'").empty?
  unless tv_exists
    screenshot_and_raise "could not find text view #{text_view}"
  end
  ph_arr = query("textView marked:'#{text_view}' child label", :text)
  if ph_arr.empty?
    screenshot_and_raise "could not find placeholder label in text view #{text_view}"
  end
  actual = ph_arr[0]
  unless actual.eql? placeholder
    screenshot_and_raise "could not find placeholder text '#{placeholder}'"
  end
end

Then /^I touch text view "([^"]*)"$/ do |text_view|
  touch("textView marked:'#{text_view}'")
  step_pause
end
