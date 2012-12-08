include Briar::Bars
include Briar::Core

Then /^I touch the "([^"]*)" toolbar button$/ do |name|
  toolbar_button_exists? name
  touch("toolbarTextButton marked:'#{name}'")
  step_pause
end
