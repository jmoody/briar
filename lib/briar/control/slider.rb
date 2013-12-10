require 'calabash-cucumber'

module Briar
  module Control
    module Slider

      def briar_args_for_slider_set_value(options)
        args = []
        if options.has_key?(:notify_targets)
          args << options[:notify_targets] ? 1 : 0
        else
          args << 1
        end

        if options.has_key?(:animate)
          args << options[:animate] ? 1 : 0
        else
          args << 1
        end
        args
      end

      def briar_slider_set_value(slider_id, value, options = {:animate => true,
                                                              :notify_targets => true})
        value_str = value.to_f.to_s
        args = briar_args_for_slider_set_value(options)
        query_str = "slider marked:'#{slider_id}'"
        views_touched = map(query_str, :changeSlider, value_str, *args)
        if views_touched.empty? or views_touched.member? '<VOID>'
          screenshot_and_raise "could not slider marked '#{slider_id}' to '#{value}' using query '#{query_str}' with options '#{options}'"
        end

        views_touched
      end


      # WARNING: requires a tap gesture recognizer on the slider
      # you have been warned
      def change_slider_value_to(slider_id, value)
        target = value.to_f
        if target < 0
          pending "value '#{value}' must be >= 0"
        end
        min_val = query("slider marked:'#{slider_id}'", :minimumValue).first
        # will not work for min_val != 0
        if min_val != 0
          pending "sliders with non-zero minimum values are not supported - slider '#{slider_id}' has minimum value of '#{min_val}'"
        end
        max_val = query("slider marked:'#{slider_id}'", :maximumValue).first
        if target > max_val
          screenshot_and_raise "cannot change slider '#{slider_id}' to '#{value}' because the maximum allowed value is '#{max_val}'"
        end
        # the x offset is from the middle of the slider.
        # ex.  slider from 0 to 5
        #      to touch 3, x must be 0
        #      to touch 0, x must be -2.5
        #      to touch 5, x must be 2.5
        half_val = (max_val/2)
        width = query("slider marked:'#{slider_id}'", :frame).first["Width"]
        x = ((width/2) * ((target - half_val)/half_val)).ceil
        touch("slider marked:'#{slider_id}'", {:offset => {:x => x, :y => 0}})
        #current = query("slider marked:'#{slider_id}'", :value).first
        #puts "current => at '#{current}' with x => '#{x}'"
      end
    end
  end
end
