require 'calabash-cucumber'

module Briar
  module UIAKeyboard
    # use the apple localization codes
    BRIAR_LANGUAGE_KEYS = {
          :en => 'space',
          :de => 'Leerzeichen',
          # could not decide what the language code should be (alt was ja-JP)
          :ja => '空白'
    }

    # work in progress
    # the number of buttons on the keyboard will be
    # 3 <== there is no international button
    # 4 <== there is an international button
    def keyboard_has_international? (opts={})
      default_opts = {:await_keyboard => false}
      opts = default_opts.merge(opts)
      await_keyboard if opts[:await_keyboard]
      res = uia('UIATarget.localTarget().frontMostApp().keyboard().buttons().length')
      button_count = res['value']
      button_count == 4
    end

    def touch_international_key(opts={})
      default_opts = {:await_keyboard => false,
                      :step_pause => 0.4}
      opts = default_opts.merge(opts)

      await_keyboard if opts[:await_keyboard]

      unless keyboard_has_international?
        screenshot_and_raise 'could not find an international key on the keyboard'
      end

      # the international button will be at index 1
      # 3 <== return key
      # 2 <== Dictation key
      # 1 <== International key
      # 0 <== shift key
      res = uia('UIATarget.localTarget().frontMostApp().keyboard().buttons()[1].tap()')
      # sleep for a moment and let the keyboard settle into the new language
      sleep(opts[:step_pause])
      res
    end


    # work in progress
    # when looking at elements() the space bar will be at the penultimate index
    # when looking at keys() the space bar index seems to float around
    def spacebar_label (opts={})
      default_opts = {:await_keyboard => false}
      opts = default_opts.merge(opts)
      await_keyboard if opts[:await_keyboard]
      elm_count = uia('UIATarget.localTarget().frontMostApp().keyboard().elements().length')['value']
      spacebar_idx = elm_count - 2
      res = uia("UIATarget.localTarget().frontMostApp().keyboard().elements()[#{spacebar_idx}].label()")
      res['value']
    end

    def spacebar_has_label?(label, opts={})
      default_opts = {:await_keyboard => false}
      opts = default_opts.merge(opts)
      await_keyboard if opts[:await_keyboard]
      spacebar_label.eql?(label)
    end

    def english_keyboard? (opts={})
      default_opts = {:await_keyboard => false}
      opts = default_opts.merge(opts)
      await_keyboard if opts[:await_keyboard]
      spacebar_has_label? BRIAR_LANGUAGE_KEYS[:en]
    end

    def german_keyboard? (opts={})
      default_opts = {:await_keyboard => false}
      opts = default_opts.merge(opts)
      await_keyboard if opts[:await_keyboard]
      spacebar_has_label? BRIAR_LANGUAGE_KEYS[:de]
    end

    def romaji_keyboard? (opts={})
      default_opts = {:await_keyboard => false}
      opts = default_opts.merge(opts)
      await_keyboard if opts[:await_keyboard]
      spacebar_has_label? BRIAR_LANGUAGE_KEYS[:ja]
    end

    def touch_international_until_language(language_key, opts={})
      default_opts = {:await_keyboard => false}
      opts = default_opts.merge(opts)
      await_keyboard if opts[:await_keyboard]

      unless keyboard_has_international?
        screenshot_and_raise 'keyboard does not have an international key'
      end

      target = BRIAR_LANGUAGE_KEYS[language_key]
      if target.nil?
        screenshot_and_raise "unknown language key '#{language_key}'"
      end

      stop_at = spacebar_label
      return if target.eql?(stop_at)

      touch_international_key

      current = spacebar_label
      loop do
        break if current.eql?(target)
        touch_international_key
        current = spacebar_label
        if current.eql?(stop_at)
          screenshot_and_raise "could not find keyboard using key '#{language_key}' and space bar label '#{target}'"
        end
      end
    end

    def is_numeric_keyboard?(opts={})
      default_opts = {:await_keyboard => false}
      opts = default_opts.merge(opts)
      await_keyboard if opts[:await_keyboard]
      res = uia('UIATarget.localTarget().frontMostApp().keyboard().keys().length')['value']
      res == 12
    end

    def briar_keyboard_send_numeric_backspace(opts={})
      default_opts = {:await_keyboard => false}
      opts = default_opts.merge(opts)
      await_keyboard if opts[:await_keyboard]
      if ios7?
        uia('UIATarget.localTarget().frontMostApp().keyboard().buttons()[0].tap()')
      else
        keyboard_enter_char 'Delete'
      end
    end

    def briar_keyboard_send_backspace(opts={})
      default_opts = {:await_keyboard => false}
      opts = default_opts.merge(opts)
      await_keyboard if opts[:await_keyboard]
      if is_numeric_keyboard?
        briar_keyboard_send_numeric_backspace
      else
        briar_keyboard_send_backspace
      end
    end

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

  end
end
