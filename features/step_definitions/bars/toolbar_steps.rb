Then /^I touch the "([^"]*)" toolbar button$/ do |name|
  touch_toolbar_button name
end

When /^I touch the "([^"]*)" toolbar button, then I should see the "([^"]*)" view$/ do |button_name, view_id|
  touch_toolbar_button button_name, {:wait_for_view => view_id}
end

