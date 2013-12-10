require 'calabash-cucumber'

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
        controls = query('segmentedControl', AI)
        controls.index(control_id)
      end

      def index_of_segment_with_name_in_control_with_id(segment_id, control_id)
        qstr = "segmentedControl marked:'#{control_id}'"
        num_segs = query(qstr, :numberOfSegments).first.to_i
        idx = 0
        while idx < num_segs
          title = query(qstr, {titleForSegmentAtIndex: idx}).first
          return idx if title.eql?(segment_id)
          idx = idx + 1
        end
        return nil
      end

      def should_see_segment_with_selected_state (control_id, segment_id, selected_state)
        @segment_id = segment_id
        @control_id = control_id
        res = query("segmentedControl marked:'#{control_id}' child segment marked:'#{segment_id}'",
                    :isSelected)
        if res.empty?
          screenshot_and_raise "expected to see segmented control '#{control_id}' with segment '#{segment_id}'"
        end

        unless res.first.to_i == selected_state
          screenshot_and_raise "expected to see segment '#{segment_id}' in '#{control_id}' with selection state '#{selected_state}' but found '#{res.to_i}'"
        end
      end

      def touch_segment(segment_id, control_id)
        @segment_id = segment_id
        @control_id = control_id
        touch("segmentedControl marked:'#{control_id}' child segment marked:'#{segment_id}'")
        step_pause
      end

      def should_see_control_with_segment_titles (control_id, segment_titles)
        @control_id = control_id
        should_see_view control_id
        tokens = tokenize_list(segment_titles)
        tokens.each do |token|
          token.strip!
        end
        counter = 0
        tokens.each do |expected|
          idx = index_of_segment_with_name_in_control_with_id expected, control_id
          unless idx == counter
            actual = query("segmentedControl marked:'#{control_id}'", {titleForSegmentAtIndex: counter}).first
            screenshot_and_raise "expected to see segment '#{expected}' at index '#{counter}' but found '#{actual}'"
          end
          counter = counter + 1
        end
      end
    end
  end
end
