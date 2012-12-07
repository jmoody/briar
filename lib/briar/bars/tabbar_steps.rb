def tabbar_visible?
  element_exists("view marked:'tabbar'")
end

def should_see_tabbar
  unless tabbar_visible?
    screenshot_and_raise "i do not see the tabbar"
  end
end

def index_of_tabbar_item(name)
  if tabbar_visible?
    tabs = query('tabBarButton', :accessibilityLabel)
    tabs.index(name)
  end
end

def touch_tabbar_item(name)
  idx = index_of_tabbar_item name
  if idx
    touch "tabBarButton index:#{idx}"
    step_pause
  else
    screenshot_and_raise "tabbar button with name #{name} does not exist"
  end
end

def tabbar_item_is_at_index(name, index)
  tabs = query('tabBarButton', :accessibilityLabel)
  tabs.index(name) == index.to_i
end

Then /^I should see tabbar button "([^"]*)" at index (\d+)$/ do |name, index|
  unless tabbar_item_is_at_index(name, index)
    screenshot_and_raise "tabbar button with name #{name} does not exist at index " +
                               index.to_s
  end
end

Given /^that the tabbar is visible$/ do
  should_see_tabbar
end

Given /^that I see "([^"]*)" home view$/ do |name|
  touch_tabbar_item(name)
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

