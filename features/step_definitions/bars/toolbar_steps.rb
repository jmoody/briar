include Briar::Bars
include Briar::Core

Then /^I touch the "([^"]*)" toolbar button$/ do |name|
  should_see_toolbar_button name
  text_button_arr = query("toolbar child toolbarTextButton child button child buttonLabel", :text)
  has_text_button = text_button_arr.index(name) != nil
  ## look for non_text button
  #toolbar_button_arr = query("toolbar marked:'toolbar' child toolbarButton", :accessibilityLabel)
  #has_toolbar_button = toolbar_button_arr.index(name) != nil

  touch_str = has_text_button ?
        "toolbarTextButton marked:'#{name}'" :
        "toolbar child toolbarButton marked:'#{name}'"
  touch(touch_str)
  step_pause
end
