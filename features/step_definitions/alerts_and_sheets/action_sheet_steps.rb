Then /^I touch the "([^"]*)" button on the action sheet$/ do |button_title|
  wait_for_animation
  wait_for_animation
  touch("actionSheet child button marked:'#{button_title}'")
  wait_for_animation
end
