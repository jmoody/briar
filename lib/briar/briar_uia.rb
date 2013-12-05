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
