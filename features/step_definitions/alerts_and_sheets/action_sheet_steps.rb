Then /^I touch the "([^"]*)" button on the action sheet$/ do |button_title|
  timeout = 1.0
  msg = "waited for '#{timeout}' seconds but did not see sheet with button '#{button_title}'"
  options = {:timeout => timeout,
             :retry_frequency => BRIAR_WAIT_RETRY_FREQ,
             :post_timeout => BRIAR_WAIT_STEP_PAUSE,
             :timeout_message => msg}
  wait_for(options) do
    not query('actionSheet').empty?
  end
  touch_sheet_button button_title
end
