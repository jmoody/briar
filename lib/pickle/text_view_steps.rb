def text_view_exists? (name)
  !query("textView marked:'#{name}'").empty?
end

def should_see_text_view (name)
  unless text_view_exists? name
    screenshot_and_raise "i do not see text view with id #{name}"
  end
end

def should_not_see_text_view (name)
  if text_view_exists? name
    screenshot_and_raise "i should not see text view with name #{name}"
  end
end

Then /^I clear text view named "([^\"]*)"$/ do |name|
  res = query("textView marked:'#{name}'")
  if res
    set_text("textView marked:'#{name}'", "")
  end
end

Then /^I should not see "([^"]*)" text view$/ do |name|
  should_not_see_text_view (name)
end

Then /^I clear note pad named "([^\"]*)"$/ do |name|
  query_str = "view:'DTNotePadView' marked:'comments' child textView"
  res = !query(query_str).empty?
  if res
    set_text(query_str, "")
  end
end

Then /^I should see the text I just entered in the "([^"]*)" text view$/ do |text_view_id|
  should_see_text_view text_view_id
  text = query("textView marked:'#{text_view_id}'", :text).first
  unless @text_entered_by_keyboard.eql? text
    screenshot_and_raise "i expected to see '#{@text_entered_by_keyboard}' in text view '#{text_view_id}' but found '#{text}'"
  end
end

Then /^I am done text editing$/ do
  touch_navbar_item "done text editing"
end
