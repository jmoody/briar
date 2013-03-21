#include Briar::TextView

Then /^I clear text view named "([^\"]*)"$/ do |name|
  res = query("textView marked:'#{name}'")
  if res
    set_text("textView marked:'#{name}'", '')
  end
end

Then /^I should not see "([^"]*)" text view$/ do |name|
  should_not_see_text_view (name)
end

Then /^I should see the text I just entered in the "([^"]*)" text view$/ do |text_view_id|
  should_see_text_view text_view_id
  text = query("textView marked:'#{text_view_id}'", :text).first
  unless @text_entered_by_keyboard.eql? text
    screenshot_and_raise "i expected to see '#{@text_entered_by_keyboard}' in text view '#{text_view_id}' but found '#{text}'"
  end
end

Then /^I am done text editing$/ do
  touch_navbar_item 'done text editing'
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
  sleep(STEP_PAUSE)
end
