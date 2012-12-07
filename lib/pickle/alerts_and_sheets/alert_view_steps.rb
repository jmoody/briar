def alert_button_exists? (button_id)
  query("alertView child button child label", :text).include?(button_id)
end

def should_see_alert_button (button_id)
  unless alert_button_exists? button_id
    screenshot_and_raise "could not find alert view with button '#{button_id}'"
  end
end

Then /^I should see alert with "([^"]*)" button$/ do |button_id|
  should_see_alert_button button_id
end

Then /^I should see alert with title "([^"]*)"$/ do |title|
  unless query("alertView child label", :text).include?(title)
    screenshot_and_raise "i do not see an alert view with title '#{title}'"
  end
end


Then /^I should see alert with message "([^"]*)"$/ do |message|
  unless query("alertView child label", :text).include?(message)
    screenshot_and_raise "i do not see an alert view with message '#{message}'"
  end
end

Then /^I should not see an alert$/ do
  res = query("alertView")
  unless res.empty?
    screenshot_and_raise "i expected to see no alert view, but found '#{res}'"
  end
end
