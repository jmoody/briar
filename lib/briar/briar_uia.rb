require 'calabash-cucumber'

module Briar
  module UIA

    def uia_available?
      # proxy for testing if run_loop exists
      not uia_not_available?
    end

    def uia_not_available?
      default_device.nil?
    end

    # use the apple localization codes
    BRIAR_LANGUAGE_KEYS = {
          :en => 'space',
          :de => 'Leerzeichen',
          # could not decide what the language code should be (alt was ja-JP)
          :ja => '空白'
    }

    def keyboard_has_international? ()
      # work in progress
      # the number of buttons on the keyboard will be
      # 3 <== there is no international button
      # 4 <== there is an international button
      await_keyboard
      res = uia('UIATarget.localTarget().frontMostApp().keyboard().buttons().length')
      button_count = res['value']
      button_count == 4
    end

    def touch_international_key(opts={})
      default_opts = {:step_pause => 0.4}
      opts = default_opts.merge(opts)
      await_keyboard
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


    def spacebar_label
      # work in progress
      # when looking at elements() the space bar will be at the penultimate index
      # when looking at keys() the space bar index seems to float around
      await_keyboard
      elm_count = uia('UIATarget.localTarget().frontMostApp().keyboard().elements().length')['value']
      spacebar_idx = elm_count - 2
      res = uia("UIATarget.localTarget().frontMostApp().keyboard().elements()[#{spacebar_idx}].label()")
      res['value']
    end

    def spacebar_has_label?(label)
      await_keyboard
      spacebar_label.eql?(label)
    end

    def english_keyboard?
      spacebar_has_label? BRIAR_LANGUAGE_KEYS[:en]
    end

    def german_keyboard?
      spacebar_has_label? BRIAR_LANGUAGE_KEYS[:de]
    end

    def romaji_keyboard?
      spacebar_has_label? BRIAR_LANGUAGE_KEYS[:ja]
    end

    def touch_international_until_language(language_key)
      await_keyboard

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

    def each_key
      ('a'..'z').each { |letter|
        begin
          uia("UIATarget.localTarget().frontMostApp().keyboard().typeString('\\#{letter}')")
          sleep(0.5)
        rescue
          puts "#{letter} ==> error"
        end
      }
    end

    def each_number
      ('0'..'9').each { |letter|
        begin
          uia("UIATarget.localTarget().frontMostApp().keyboard().typeString('\\#{letter}')")
          sleep(0.5)
        rescue
          puts "#{letter} ==> error"
        end
      }
    end




      def uia_handle_target_command(cmd, *query_args)
      args = query_args.map do |part|
        if part.is_a?(String)
          "#{escape_uia_string(part)}"
        else
          "#{escape_uia_string(part.to_edn)}"
        end
      end
      command = %Q[target.#{cmd}(#{args.join(', ')})]
      if ENV['DEBUG'] == '1'
        puts 'Sending UIA command'
        puts command
      end
      s=send_uia_command :command => command
      if ENV['DEBUG'] == '1'
        puts 'Result'
        p s
      end
      if s['status'] == 'success'
        s['value']
      else
        raise s
      end
    end

    def uia_touch_with_options(point, opts={})
      defaults = {:tap_count => 1,
                  :touch_count => 1,
                  :duration => 1.0}
      opts = defaults.merge(opts)
      pt = "{x: #{point[:x]}, y: #{point[:y]}}"
      args = "{tapCount: #{opts[:tap_count]}, touchCount: #{opts[:touch_count]}, duration: #{opts[:duration]}}"
      uia_handle_target_command(:tapWithOptions, pt, args)
    end

    def dismiss_ipad_keyboard
      screenshot_and_raise 'cannot dismiss keyboard on iphone' if iphone?
      screenshot_and_raise 'cannot dismiss keyboard without launching with instruments' unless uia_available?
      send_uia_command command:"uia.keyboard().buttons()['Hide keyboard'].tap()"
      step_pause
    end

    def make_ipad_emulation_1x
      device = device()
      unless device.ipad?
        pending 'this trick only works on the iPad'
      end

      unless device.ios7?
        pending 'this trick only works on iOS 7'
      end

      unless uia_available?
        pending 'this trick requires the app be launched with instruments'
      end

      # this only works because iPhone apps emulated on iPads in iOS 7 _always_
      # launch at 2x
      uia_touch_with_options({x:738, y:24})
      step_pause
    end

    def ensure_ipad_emulation_1x
      device = device()
      if device.ipad? and device.ios7? and uia_available?
        uia_touch_with_options({x:738, y:24})
      end
    end

  end
end
