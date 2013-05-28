Then /^I should see alert with "([^"]*)" button$/ do |button_id|
  should_see_alert_button button_id
end

Then /^I should see alert with title "([^"]*)"$/ do |title|
  should_see_alert_with_title title
end

Then /^I should see alert with message "([^"]*)"$/ do |message|
  should_see_alert_with_message message
end

Then /^I should not see an alert$/ do
  should_not_see_alert
end
