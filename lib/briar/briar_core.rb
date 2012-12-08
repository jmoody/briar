require 'calabash-cucumber'

module Briar
  module Core
    STEP_PAUSE = (ENV['STEP_PAUSE'] || 0.4).to_f
    ANIMATION_PAUSE = (ENV['ANIMATION_PAUSE'] || 0.6).to_f

    def step_pause
      sleep(STEP_PAUSE)
    end

    def wait_for_animation
      sleep(ANIMATION_PAUSE)
    end


    def view_exists? (view_id)
      !query("view marked:'#{view_id}'").empty?
    end

    def should_see_view (view_id)
      unless view_exists? view_id
        screenshot_and_raise "no view found with id #{view_id}"
      end
    end

    def view_exists_with_text? (text)
      element_exists("view text:'#{text}'")
    end


    def should_see_view_after_animation (view_id)
      wait_for_animation
      should_see_view view_id
    end

    def should_not_see_view_after_animation (view_id)
      wait_for_animation
      if view_exists? view_id
        screenshot_and_raise "did not expect to see view '#{view_id}'"
      end
    end

    def should_see_view_with_text (text)
      res = view_exists_with_text? text
      unless res
        screenshot_and_raise "No view found with text #{text}"
      end
    end

    Then /^I should (see|not see) (?:the|) "([^\"]*)" view$/ do |visibility, view_id|
      if visibility.eql? "see"
        should_see_view_after_animation view_id
      else
        should_not_see_view_after_animation view_id
      end
    end


    def touch_view_named(view_id)
      touch("view marked:'#{view_id}'")
    end

  end
end
