
Given /^that the tabbar is visible$/ do
  pending "deprecated 0.0.5 - use 'Then I should see the tabbar'"
  should_see_tabbar
end

Then /^the tabbar is visible$/ do
  pending "deprecated 0.0.5 - use 'Then I should see the tabbar'"
  should_see_tabbar
end


Then /^I should( not)? see the (?:tabbar|tab bar)$/ do |visibility|
  visibility ? should_not_see_tabbar : should_see_tabbar
end

Then /^I should see (?:tabbar|tab bar) button "([^"]*)" at index (\d+)$/ do |name, index|
  should_see_tab_at_index name, index
end

Then /I touch (?:the) "([^"]*)" tab$/ do |name|
  touch_tabbar_item name
end

When /^I touch the "([^"]*)" tab I should see the "([^"]*)" view$/ do |tab_label, view_id|
  should_see_tabbar
  touch_tabbar_item tab_label
  should_see_view_after_animation view_id
end

Then /^I should see "([^"]*)" tabs$/ do |list_of_tabs|
  tabs = list_of_tabs.split(/,\s?/)
  index = 0
  tabs.each do |tab|
    should_see_tab_at_index tab.strip! || tab, index
    index = index + 1
  end
end
