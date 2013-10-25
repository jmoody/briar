module Briar
  module Alerts_and_Sheets


    # of interest
    # touch("view:'_UIModalItemAlertContentView' descendant view:'_UIModalItemTableViewCell'  marked:'OK'")

    def alert_exists? (alert_id=nil)
      if device.ios7?
        res = send_uia_command command:'uia.alert() != null'
        res['value']
      else
        if alert_id.nil?
          !query('alertView').empty?
        else
          !query("alertView marked:'#{alert_id}'").empty?
        end
      end
    end

    def should_see_alert (alert_id=nil)
      unless alert_exists? alert_id
        if alert_id.nil?
          screenshot_and_raise 'should see alert view'
        else
          screenshot_and_raise "should see alert view marked '#{alert_id}'"
        end
      end
    end

    def should_not_see_alert (alert_id=nil)
      if alert_exists? alert_id
        if alert_id.nil?
          screenshot_and_raise 'should not see alert view'
        else
          screenshot_and_raise "should not see alert view marked '#{alert_id}'"
        end
      end
    end

    def should_see_alert_with_title (title, timeout=BRIAR_WAIT_TIMEOUT)
      warn 'cannot distinguish between alert titles and messages'
      if device.ios7?
        should_see_alert()
        if uia_query(:view, marked:"#{title}").empty?
          screenshot_and_raise "expected to see alert with title '#{title}'"
        end
      else
        qstr = 'alertView child label'
        msg = "waited for '#{timeout}' for alert with title '#{title}'"
        wait_for(:timeout => timeout,
                 :retry_frequency => BRIAR_RETRY_FREQ,
                 :post_timeout => BRIAR_POST_TIMEOUT,
                 :timeout_message => msg) do
          query(qstr, :text).include?(title)
        end
      end
    end

    def should_see_alert_with_message (message)
      warn 'cannot distinguish between alert titles and messages'
      if device.ios7?
        should_see_alert()
        if uia_query(:view, marked:"#{message}").empty?
          screenshot_and_raise "expected to see alert with title '#{message}'"
        end
      else
        qstr = 'alertView child label'
        msg = "waited for '#{timeout}' for alert with message '#{message}'"
        wait_for(:timeout => timeout,
                 :retry_frequency => BRIAR_RETRY_FREQ,
                 :post_timeout => BRIAR_POST_TIMEOUT,
                 :timeout_message => msg) do
          query(qstr, :text).include?(title)
        end
      end
    end

    def alert_button_exists? (button_id)
      if device.ios7?
        should_see_alert()
        not uia_query(:view, marked:"#{button_id}").empty?
      else
        query('alertView child button child label', :text).include?(button_id)
      end
    end

    def should_see_alert_button (button_id)
      unless alert_button_exists? button_id
        screenshot_and_raise "could not find alert view with button '#{button_id}'"
      end
    end

    def dismiss_alert_with_button (button_label)
      touch_alert_button(button_label)
      if device.ios7?
        wait_for_view_to_disappear button_label
      else
        wait_for_view_to_disappear 'alertView'
      end
    end


    def touch_alert_button(button_title)
      should_see_alert()
      if device.ios7?
        touch("view marked:'#{button_title}'")
      else
        touch("alertView child button marked:'#{button_title}'")
      end
      step_pause
    end
  end
end
