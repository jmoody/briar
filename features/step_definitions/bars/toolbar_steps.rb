#include Briar::Bars
#include Briar::Core

Then /^I touch the "([^"]*)" toolbar button$/ do |name|
  should_see_toolbar_button name
  touch("toolbar descendant view marked:'#{name}'")
  step_pause
end

When /^I touch the "([^"]*)" toolbar button, then I should see the "([^"]*)" view$/ do |button_name, view_id|
  should_see_toolbar_button button_name
  touch_transition("toolbar descendant view marked:'done with info'",
                     "view marked:'#{view_id}'",
                     {:timeout=>TOUCH_TRANSITION_TIMEOUT,
                      :retry_frequency=>TOUCH_TRANSITION_RETRY_FREQ})
end

