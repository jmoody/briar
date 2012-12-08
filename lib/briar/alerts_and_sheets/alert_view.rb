require 'calabash-cucumber'

module Briar
  module Alerts_and_Sheets
    def alert_button_exists? (button_id)
      query("alertView child button child label", :text).include?(button_id)
    end

    def should_see_alert_button (button_id)
      unless alert_button_exists? button_id
        screenshot_and_raise "could not find alert view with button '#{button_id}'"
      end
    end

  end
end
