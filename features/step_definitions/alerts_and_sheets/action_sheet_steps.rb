Then /^I touch the "([^"]*)" button on the action sheet$/ do |button_title|
  timeout = 1.0
  msg = "waited for '#{timeout}' seconds but did not see sheet with button '#{button_title}'"
  options = {:timeout => timeout,
             :retry_frequency => 0.2,
             :post_timeout => 0.1,
             :timeout_message => msg}
  wait_for(options) do
    not query('actionSheet').empty?
  end
  touch_sheet_button button_title
end
