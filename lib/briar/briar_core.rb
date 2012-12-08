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

  end
end
