module Briar
  module Alerts_and_Sheets
    def alert_exists? (alert_id)
      !query("alertView marked:'#{alert_id}'").empty?
    end

    def should_see_alert (alert_id)
      unless alert_exists? alert_id
        screenshot_and_raise "should see alert view marked '#{alert_id}'"
      end
    end

    def should_not_see_alert (alert_id)
      if alert_exists? alert_id
        screenshot_and_raise "should not see alert view marked '#{alert_id}'"
      end
    end

    def alert_button_exists? (button_id)
      query('alertView child button child label', :text).include?(button_id)
    end

    def should_see_alert_button (button_id)
      unless alert_button_exists? button_id
        screenshot_and_raise "could not find alert view with button '#{button_id}'"
      end
    end

    def dismiss_alert_with_button (button_label)
      touch("alertView child button marked:'#{button_label}'")
    end

  end
end
