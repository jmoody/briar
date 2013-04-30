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
        screenshot_and_raise "should see view with id '#{view_id}'"
      end
    end

    def should_not_see_view (view_id)
      if view_exists? view_id
        screenshot_and_raise "should not see view with id '#{view_id}'"
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
        screenshot_and_raise "should not see view with id '#{view_id}'"
      end
    end

    def should_see_view_with_text (text)
      res = view_exists_with_text? text
      unless res
        screenshot_and_raise "should see view with text '#{text}'"
      end
    end

    def touch_view_named(view_id)
      touch("view marked:'#{view_id}'")
    end


    def wait_for_view (view_id, timeout=1.0)
      msg = "waited for '#{timeout}' seconds but did not see '#{view_id}'"
      wait_for(:timeout => timeout,
               :retry_frequency => 0.2,
               :post_timeout => 0.1,
               :timeout_message => msg ) do
        view_exists? view_id
      end
    end

    def wait_for_views(views, timeout=1.0)
      msg = "waited for '#{timeout}' seconds but did not see '#{views}'"
      options = {:timeout => timeout,
                 :retry_frequency => 0.2,
                 :post_timeout => 0.1,
                 :timeout_message => msg}
      wait_for(options) do
        views.all? { |view_id| view_exists?(view_id) }
      end
    end

    def wait_for_view_to_disappear(view_id, timeout=1.0)
      msg = "waited for '#{timeout}' seconds for '#{view_id}' to disappear but it is still visible"
      options = {:timeout => timeout,
                 :retry_frequency => 0.2,
                 :post_timeout => 0.1,
                 :timeout_message => msg}
      wait_for(options) do
        not view_exists? view_id
      end
    end

    def touch_and_wait_to_disappear(view_id, timeout=1.0)
      touch("view marked:'#{view_id}'")
      wait_for_view_to_disappear view_id, timeout
    end
  end
end
