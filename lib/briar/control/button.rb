require 'calabash-cucumber'

module Briar
  module Control
    module Button
      include Briar::Core

      def button_exists? (button_id)
        res = query("button marked:'#{button_id}'", :alpha)
        if res.empty?
          false
        else
          res.first.to_i != 0
        end
      end

      def should_see_button (button_id)
        wait_for_button button_id
      end

      def should_not_see_button (button_id)
        screenshot_and_raise "i should not see button marked '#{button_id}'" if button_exists?(button_id)
      end

      def button_is_enabled (name)
        enabled = query("button marked:'#{name}' isEnabled:1", AI).first
        enabled.eql? name
      end

      def should_see_button_with_title(name, title)
        should_see_button name
        if query("button marked:'#{name}' child label", :text).empty?
          screenshot_and_raise "i do not see a button marked '#{name}' with title '#{title}'"
        end
      end

      def touch_button (button_id)
        should_see_button button_id
        touch("button marked:'#{button_id}'")
      end

      def touch_button_and_wait_for_view (button_id, view_id, timeout=BRIAR_WAIT_TIMEOUT)
        touch_button(button_id)
        unless view_id.nil?
          wait_for_view view_id, timeout
        end
      end

      def touch_button_and_wait_for_view_to_disappear (button_id, view_id, timeout=BRIAR_WAIT_TIMEOUT)
        touch_button button_id
        wait_for_view_to_disappear view_id, timeout
      end


      def wait_for_button (button_id, timeout=BRIAR_WAIT_TIMEOUT)
        msg = "waited for '#{timeout}' seconds but did not see button '#{button_id}'"
        wait_for(:timeout => timeout,
                 :retry_frequency => BRIAR_WAIT_RETRY_FREQ,
                 :post_timeout => BRIAR_WAIT_STEP_PAUSE,
                 :timeout_message => msg) do
          button_exists? button_id
        end
      end

      def wait_for_button_with_title (button_id, title, timeout=BRIAR_WAIT_TIMEOUT)
        msg = "waited for '#{timeout}' seconds but did not see button '#{button_id}' with title '#{title}'"
        wait_for(:timeout => timeout,
                 :retry_frequency => BRIAR_WAIT_RETRY_FREQ,
                 :post_timeout => BRIAR_WAIT_STEP_PAUSE,
                 :timeout_message => msg) do
          button_exists? button_id
        end
        should_see_button_with_title(button_id, title)
      end
    end
  end
end

