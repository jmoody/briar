require 'calabash-cucumber'

module Briar
  module UIAKeyboard
    def uia_keyboard_visible?
      res = uia('UIATarget.localTarget().frontMostApp().keyboard()')['value']
      not res.eql?(':nil')
    end

    def uia_await_keyboard(opts={})
      default_opts = {:timeout => BRIAR_WAIT_TIMEOUT,
                      :retry_frequency => BRIAR_WAIT_RETRY_FREQ,
                      :post_timeout => BRIAR_WAIT_STEP_PAUSE}
      opts = default_opts.merge(opts)
      unless opts[:timeout_message]
        msg = "waited for '#{opts[:timeout]}' for keyboard"
        opts[:timeout_message] = msg
      end

      wait_for(opts) do
        uia_keyboard_visible?
      end
    end

    def dismiss_ipad_keyboard
      screenshot_and_raise 'cannot dismiss keyboard on iphone' if iphone?
      screenshot_and_raise 'cannot dismiss keyboard without launching with instruments' unless uia_available?
      send_uia_command command: "uia.keyboard().buttons()['Hide keyboard'].tap()"
      step_pause
    end
  end
end




