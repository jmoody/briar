
When /^I touch (?:the|a) "([^"]*)" button, then I should see the "([^"]*)" view$/ do |button_id, view_id|
  touch_button_and_wait_for_view button_id, view_id
end

Then /^I touch (?:the|a) "([^"]*)" button and wait for (?:the|a) "([^"]*)" view$/ do |button_id, view_id|
  touch_button_and_wait_for_view button_id, view_id
end

Then /^I should see (?:the|a) "([^"]*)" button has title "([^"]*)"$/ do |button_id, title|
  should_see_button_with_title button_id, title
end

# as of 0.9.136 - I should (not)? see a ... button
#  conflicts with calabash predefined steps
Then /^I should( not)? see (?:the|an) "([^"]*)" button$/ do |visibility, button_id|
  visibility ? should_not_see_button(button_id) : should_see_button(button_id)
end

Then /^I should see (?:the|a) "([^"]*)" button is (disabled|enabled)$/ do |button_id, state|
  res = query("button marked:'#{button_id}'", :isEnabled).first
  str_state = state.eql?('disabled') ? '0' : '1'
  unless res.eql?(str_state)
    screenshot_and_raise "expected to see '#{button_id}' that is '#{state}' but found '#{res}'"
  end
end
