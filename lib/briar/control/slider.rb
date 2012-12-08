require 'calabash-cucumber'

module Briar
  module Control
    module Slider
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
