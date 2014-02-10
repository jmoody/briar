When /^I change the "([^"]*)" slider to (\d+)$/ do |slider_id, value|
  wait_for_query("slider marked:'#{slider_id}'")
  change_slider_value_to slider_id, value
  step_pause
  @slider_that_was_changed = slider_id
  @slider_new_value = value
end


