def button_exists? (name)
  res = query("button marked:'#{name}'", :alpha)
  if res.empty?
    false
  else
    res.first.to_i != 0
  end
end

def should_see_button (name)
  unless button_exists? name
    screenshot_and_raise "i did not see a button with marked #{name}"
  end
end

def should_not_see_button (button_id)
  screenshot_and_raise "i should not see button marked '#{button_id}'" if button_exists?(button_id)
end

def button_is_enabled (name)
  enabled = query("button marked:'#{name}' isEnabled:1", :accessibilityIdentifier).first
  enabled.eql? name
end

def should_see_button_with_title(name, title)
  should_see_button name
  if query("button marked:'#{title}' child label", :text).empty?
    screenshot_and_raise "i do not see a button marked #{name} with title #{title}"
  end
end

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

def touch_button (name)
  should_see_button name
  touch("button marked:'#{name}'")
  step_pause
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
