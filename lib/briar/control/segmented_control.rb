module Briar
  module Control
    module Segmented_Control

      def query_str_for_control (control_id=nil)
        if control_id.nil?
          'segmentedControl'
        else
          "segmentedControl marked:'#{control_id}'"
        end
      end

      def index_of_control_with_id (control_id)
        controls = query('segmentedControl', :accessibilityIdentifier)
        controls.index(control_id)
      end

      def index_of_segment_with_name_in_control_with_id(segment_id, control_id)
        control_idx = index_of_control_with_id (control_id)
        if control_idx
          titles = query("segmentedControl index:#{control_idx} child segment child segmentLabel", :text).reverse
          titles.index(segment_id)
        else
          nil
        end
      end

      def should_see_segment_with_selected_state (control_id, segment_id, selected_state)
        @segment_id = segment_id
        @control_id = control_id
        control_idx = index_of_control_with_id control_id
        if control_idx
          segment_idx = index_of_segment_with_name_in_control_with_id(segment_id, control_id)
          if segment_idx
            selected_arr = query("segmentedControl index:#{control_idx} child segment", :isSelected).reverse
            res = selected_arr[segment_idx]
            unless res.to_i == selected_state
              screenshot_and_raise "found segment named #{segment_id} in  #{control_id}, but it was _not_ selected"
            end
          else
            screenshot_and_raise "could not find #{segment_id} in #{control_id}"
          end
        else
          screenshot_and_raise "could not find control named #{control_id}"
        end
      end

      def touch_segment(segment_id, control_id)
        @segment_id = segment_id
        @control_id = control_id
        idx = index_of_control_with_id control_id
        if idx
          touch("segmentedControl index:#{idx} child segment child segmentLabel marked:'#{segment_id}'")
          wait_for_animation
        else
          screenshot_and_raise "could not find segmented control with name #{control_id}"
        end
      end

      def should_see_control_with_segment_titles (control_id, segment_titles)
        @control_id = control_id
        should_see_view control_id
        tokens = segment_titles.split(',')
        tokens.each do |token|
          token.strip!
        end
        idx = index_of_control_with_id control_id
        if idx
          actual_titles = query("segmentedControl index:#{idx} child segment child segmentLabel", :text).reverse
          counter = 0
          tokens.zip(actual_titles).each do |expected, actual|
            unless actual.eql? expected
              screenshot_and_raise "when inspecting #{control_id} i expected title: #{expected} but found: #{actual} at index #{counter}"
            end
            counter = counter + 1
          end
        else
          screenshot_and_raise "could not find segmented control with name #{control_id}"
        end
      end
    end
  end
end
