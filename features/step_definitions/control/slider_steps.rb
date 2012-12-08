include Briar::Control::Slider

When /^I change the "([^"]*)" slider to (\d+)$/ do |slider_id, value|
  change_slider_value_to slider_id, value
  @slider_that_was_changed = slider_id
  @slider_new_value = value
end


