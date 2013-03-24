#include Briar::Bars

# navigation back item, distinct from left bar button item
Then /^I should see navbar back button$/ do
  should_see_navbar_back_button
end

Then /^I should see a back button in the navbar$/ do
  should_see_navbar_back_button
end

# navigation back item, distinct from left bar button item
Then /^I should not see navbar back button$/ do
  if navbar_has_back_button?
    screenshot_and_raise 'there should be no navigation bar back button'
  end
end

Then /^I touch navbar button "([^"]*)"$/ do |name|
  touch_navbar_item(name)
end

Then /^I touch right navbar button$/ do
  touch('navigationButton index:1')
  step_pause
end


Then /^I should see navbar with title "([^\"]*)"$/ do |title|
  navbar_should_have_title title
end


Then /^I should (not see|see) (?:the|an?) "([^"]*)" button in the navbar$/ do |visibility, name|
  if visibility.eql? 'see'
    should_see_navbar_button name
  else
    should_not_see_navbar_button name
  end
end

When /^I touch the "([^"]*)" navbar button, then I should see the "([^"]*)" view$/ do |button_name, view_id|
  idx = index_of_navbar_button button_name
  if idx
    touch_transition("navigationButton index:#{idx}",
                     "view marked:'#{view_id}'",
                     {:timeout=>TOUCH_TRANSITION_TIMEOUT,
                      :retry_frequency=>TOUCH_TRANSITION_RETRY_FREQ})
  else
    screenshot_and_raise "could not find navbar item '#{button_name}'"
  end
end

Then /^I go back after waiting$/ do
  go_back_after_waiting
end

Then /^I go back and wait for "([^\"]*)"$/ do |view|
  go_back_and_wait_for_view view
end

Then /^I touch the "([^"]*)" navbar button$/ do |name|
  touch_navbar_item name
end

Then /^I should see that the navbar has title "([^"]*)"$/ do |title|
  navbar_should_have_title title
end

Then /^I touch the "([^"]*)" button in the navbar$/ do |name|
  touch_navbar_item name
end

Then /^I should see a back button in the navbar with the title "([^"]*)"$/ do |title|
  if query("navigationItemButtonView marked:'#{title}'").empty?
    screenshot_and_raise "the navbar should have a back button with title #{title}"
  end
end

When /^I go back, I should see the "([^"]*)" view$/ do |view_id|
  touch_transition('navigationItemButtonView first',
                   "view marked:'#{view_id}'",
                   {:timeout=>TOUCH_TRANSITION_TIMEOUT,
                    :retry_frequency=>TOUCH_TRANSITION_RETRY_FREQ})
end

Then /^I should see today's date in the navbar$/ do
  now = Time.now
  unless date_is_in_navbar(now)
    with_leading = now.strftime('%a %b %d')
    without_leading = now.strftime("%a %b #{date.day}")
    screenshot_and_raise "could not find #{with_leading} or #{without_leading} " +
                               'in the date bar'
  end
end
