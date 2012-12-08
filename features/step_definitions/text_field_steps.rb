def text_field_exists? (name)
  !query("textField marked:'#{name}'").empty?
end

def should_see_text_field (name)
  res = text_field_exists? name
  unless res
    screenshot_and_raise "could not find text field with name #{name}"
  end
end

def should_not_see_text_field (name)
  res = text_field_exists? name
  if res
    screenshot_and_raise "i should not see text field with name #{name}"
  end
end

Then /^I should see the "([^"]*)" text field$/ do |name|
  should_see_text_field name
end

Then /^I should not see "([^"]*)" text field$/ do |name|
  should_not_see_text_field name
end

def button_in_text_field_is_clear? (text_field_id)
  ht = query("textField marked:'#{text_field_id}' child button child imageView", :frame).first
  if !ht.nil?
    ht["X"] == 0 and ht["Y"] == 0 and ht["Width"] == 19 and ht["Height"] == 19
  else
    false
  end
end

def should_see_clear_button_in_text_field (text_field_id)
  unless button_in_text_field_is_clear? text_field_id
    screenshot_and_raise "expected to see clear button in text field #{text_field_id}"
  end
end

def should_not_see_clear_button_in_text_field (text_field_id)
  if button_in_text_field_is_clear? text_field_id
    screenshot_and_raise "did NOT expected to see clear button in text field #{text_field_id}"
  end
end

Then /^I touch the clear button in the "([^"]*)" text field$/ do |name|
  should_see_clear_button_in_text_field name
  touch("textField marked:'#{name}' child button")
  step_pause
end


Then /^I should see a clear button in the text field in the "([^"]*)" row$/ do |row_id|
  query_str = "tableViewCell marked:'#{row_id}' child tableViewCellContentView child textField"
  res = query(query_str)
  screenshot_and_raise "expected to see text field in '#{row_id}' row" if res.empty?
end


Then /^I touch the clear button in the text field in the "([^"]*)" row$/ do |row_id|
  query_str = "tableViewCell marked:'#{row_id}' child tableViewCellContentView child textField"
  res = query(query_str)
  screenshot_and_raise "expected to see text field in '#{row_id}' row" if res.empty?
  touch("#{query_str} child button")
  step_pause
end

def text_field_exists_with_text?(text_field, text)
  actual = query("textField marked:'#{text_field}'", :text).first
  actual.eql? text
end

def should_see_text_field_with_text (text_field, text)
  unless text_field_exists_with_text? text_field, text
    actual = query("textField marked:'#{text_field}'", :text).first
    screenshot_and_raise "i expected to see text field named '#{text_field}' with text '#{text}' but found '#{actual}'"
  end
end


Then /^I should see "([^"]*)" in the text field "([^"]*)"$/ do |text, text_field|
  should_see_text_field_with_text text_field, text
end
