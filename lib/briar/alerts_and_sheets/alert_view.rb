module Briar
  module Alerts_and_Sheets

    def alert_exists? (alert_id=nil)
      if alert_id.nil?
        !query('alertView').empty?
      else
        !query("alertView marked:'#{alert_id}'").empty?
      end
    end

    def should_see_alert (alert_id=nil)
      unless alert_exists? alert_id
        screenshot_and_raise "should see alert view marked '#{alert_id}'"
      end
    end

    def should_not_see_alert (alert_id=nil)
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
      wait_for_view_to_disappear 'alertView'
    end

    def should_see_alert_with_title (title)
      unless query('alertView child label', :text).include?(title)
        screenshot_and_raise "i do not see an alert view with title '#{title}'"
      end
    end

    def should_see_alert_with_message (message)
      unless query('alertView descendant label', :text).include?(message)
        screenshot_and_raise "i do not see an alert view with message '#{message}'"
      end
    end

    def touch_alert_button(button_title)
      if device.ios7?
        touch("view marked:'#{button_title}'")
      else
        touch("alertView child button marked:'#{button_title}'")
      end
      step_pause
    end
  end
end
