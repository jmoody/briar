Then /^I should see alert with "([^"]*)" button$/ do |button_id|
  should_see_alert_button button_id
end

Then /^I should see alert with title "([^"]*)"$/ do |title|
  unless query('alertView child label', :text).include?(title)
    screenshot_and_raise "i do not see an alert view with title '#{title}'"
  end
end

Then /^I should see alert with message "([^"]*)"$/ do |message|
  unless query('alertView child label', :text).include?(message)
    screenshot_and_raise "i do not see an alert view with message '#{message}'"
  end
end

Then /^I should not see an alert$/ do
  res = query('alertView')
  unless res.empty?
    screenshot_and_raise "i expected to see no alert view, but found '#{res}'"
  end
end

Then /^I see an alert with "([^\"]*)" text$/ do |message|
  wait_poll(:until_exists => "label text:'#{message}'", :timeout => 5) do
    result = query("label text:'#{message}'").empty?
    if result
      screenshot_and_raise "could not find text field with AlertView with text '#{message}'"
    end
    sleep(STEP_PAUSE)
  end
end
