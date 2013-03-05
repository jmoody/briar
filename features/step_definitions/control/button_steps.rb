#include Briar::Control::Button

Then /^I should see button "([^\"]*)" is enabled$/ do |name|
  should_see_button name
  unless button_is_enabled name
    screenshot_and_raise "i did not see that #{name} was enabled"
  end
end

Then /^I should see button "([^\"]*)" is disabled$/ do |name|
  should_see_button name
  if button_is_enabled name
    screenshot_and_raise "i did not see that #{name} was disabled"
  end
end

Then /^I touch "([^"]*)" button$/ do |name|
  touch_button name
end

When /^I touch the "([^"]*)" button, then I should see the "([^"]*)" view$/ do |button_id, view_id|
  touch_transition("button marked:'#{button_id}'",
                   "view marked:'#{view_id}'",
                   {:timeout=>TOUCH_TRANSITION_TIMEOUT,
                    :retry_frequency=>TOUCH_TRANSITION_RETRY_FREQ})
end

Then /^I touch the "([^"]*)" button and wait for (?:the|a) "([^"]*)" view$/ do |button_id, view_id|
  touch_transition("button marked:'#{button_id}'",
                   "view marked:'#{view_id}'",
                   {:timeout=>TOUCH_TRANSITION_TIMEOUT,
                    :retry_frequency=>TOUCH_TRANSITION_RETRY_FREQ})
end

Then /^I should see the "([^"]*)" button has title "([^"]*)"$/ do |button_id, title|
  should_see_button_with_title button_id, title
end

Then /^I should not see "([^"]*)" button$/ do |button_id|
  if button_exists? button_id
    screenshot_and_raise "should not see button: '#{button_id}'"
  end
end

Then /^I should see "([^"]*)" button$/ do |button_id|
  unless button_exists? button_id
    screenshot_and_raise "should see button '#{button_id}'"
  end
end

Then /^I should see the "([^"]*)" button is (disabled|enabled)$/ do |button_id, state|
  res = query("button marked:'record an urge'", :isEnabled).first
  str_state = state.eql?("disabled") ? "0" : "1"
  unless res.eql?(str_state)
    screenshot_and_raise "expected to see '#{button_id}' that is '#{state}' but found '#{res}'"
  end
end
