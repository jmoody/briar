def toolbar_button_exists? (name)
  arr = query("toolbar child toolbarTextButton child button child buttonLabel", :text)
  arr.index(name) != nil
end

def should_see_toolbar_button (name)
  res = toolbar_button_exists? name
  unless res
    screenshot_and_raise "could not see toolbar button with name #{name}"
  end
end

Then /^I touch the "([^"]*)" toolbar button$/ do |name|
  toolbar_button_exists? name
  touch("toolbarTextButton marked:'#{name}'")
  step_pause
end
