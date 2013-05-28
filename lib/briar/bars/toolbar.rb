require 'calabash-cucumber'

module Briar
  module Bars
    def toolbar_exists? (id)
      !query("toolbar marked:'#{id}'").empty?
    end

    def should_see_toolbar (id)
      screenshot_and_raise "expected to see toolbar with id '#{id}'" unless toolbar_exists? id
    end

    def should_not_see_toolbar (id)
      screenshot_and_raise "did not expect to see toolbar with id '#{id}'" if toolbar_exists? id
    end

    def toolbar_button_exists? (name_or_id)
      query("toolbar descendant view marked:#{name_or_id}")
      ## look for text button
      #text_button_arr = query("toolbar child toolbarTextButton child button child buttonLabel", :text)
      #has_text_button = text_button_arr.index(name_or_id) != nil
      ## look for non_text button
      #toolbar_button_arr = query("toolbar child toolbarButton", :accessibilityLabel)
      #has_toolbar_button = toolbar_button_arr.index(name_or_id) != nil
      #
      #has_text_button or has_toolbar_button
    end

    def should_see_toolbar_button (name_or_id)
      res = toolbar_button_exists? name_or_id
      unless res
        screenshot_and_raise "could not see toolbar button with name '#{name_or_id}'"
      end
    end

    def touch_toolbar_button(button_name, and_wait_for_view_id=nil)
      should_see_toolbar_button button_name
      if and_wait_for_view_id.nil?
        touch("toolbar descendant view marked:'#{button_name}'")
      else
        touch_transition("toolbar descendant view marked:'#{button_name}'",
                         "view marked:'#{and_wait_for_view_id}'",
                         {:timeout=>TOUCH_TRANSITION_TIMEOUT,
                          :retry_frequency=>TOUCH_TRANSITION_RETRY_FREQ})
      end
      step_pause
    end
  end
end
