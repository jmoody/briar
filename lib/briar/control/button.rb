require 'calabash-cucumber'

module Briar
  module Control
    module Button
      include Briar::Core
      def button_exists? (name)
        res = query("button marked:'#{name}'", :alpha)
        if res.empty?
          false
        else
          res.first.to_i != 0
        end
      end

      def should_see_button (name)
        unless button_exists? name
          screenshot_and_raise "i did not see a button with marked #{name}"
        end
      end

      def should_not_see_button (button_id)
        screenshot_and_raise "i should not see button marked '#{button_id}'" if button_exists?(button_id)
      end

      def button_is_enabled (name)
        enabled = query("button marked:'#{name}' isEnabled:1", :accessibilityIdentifier).first
        enabled.eql? name
      end

      def should_see_button_with_title(name, title)
        should_see_button name
        if query("button marked:'#{title}' child label", :text).empty?
          screenshot_and_raise "i do not see a button marked #{name} with title #{title}"
        end
      end

      def touch_button (name)
        should_see_button name
        touch("button marked:'#{name}'")
        step_pause
      end

      def touch_button_and_wait_for_view (button_id, view_id)
        touch_transition("button marked:'#{button_id}'",
                         "view marked:'#{view_id}'",
                         {:timeout=>TOUCH_TRANSITION_TIMEOUT,
                          :retry_frequency=>TOUCH_TRANSITION_RETRY_FREQ})
      end

      def wait_for_button_with_title (button_id, title)
        wait_for_view(button_id)
        should_see_button_with_title(button_id, title)
      end
    end
  end
end

