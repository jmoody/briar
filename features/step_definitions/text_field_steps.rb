include Briar::TextView

Then /^I should see the "([^"]*)" text field$/ do |name|
  should_see_text_field name
end

Then /^I should not see "([^"]*)" text field$/ do |name|
  should_not_see_text_field name
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


Then /^I should see "([^"]*)" in the text field "([^"]*)"$/ do |text, text_field|
  should_see_text_field_with_text text_field, text
end
