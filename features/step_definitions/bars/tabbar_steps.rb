#include Briar::Bars

Then /^I should see tabbar button "([^"]*)" at index (\d+)$/ do |name, index|
  unless tabbar_item_is_at_index(name, index)
    screenshot_and_raise "tabbar button with name #{name} does not exist at index " +
                               index.to_s
  end
end

Given /^that the tabbar is visible$/ do
  should_see_tabbar
end


Then /^I should not see the tabbar$/ do
  screenshot_and_raise "should not be able to see tabbar" if tabbar_visible?
end

Then /I touch (?:the) "([^"]*)" tab$/ do |name|
  touch_tabbar_item name
end

Then /^the tabbar is visible$/ do
  macro 'that the tabbar is visible'
end

When /^I touch the "([^"]*)" tab I should see the "([^"]*)" view$/ do |tab_label, view_id|
  should_see_tabbar
  touch_tabbar_item tab_label
  should_see_view_after_animation view_id
end

