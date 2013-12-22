require 'calabash-cucumber'

module Briar
  module UIA

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
                  :duration => 0.0}
      opts = defaults.merge(opts)
      pt = "{x: #{point[:x]}, y: #{point[:y]}}"
      args = "{tapCount: #{opts[:tap_count]}, touchCount: #{opts[:touch_count]}, duration: #{opts[:duration]}}"
      uia_handle_target_command(:tapWithOptions, pt, args)
    end

  end
end
