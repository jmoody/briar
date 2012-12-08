require "calabash-cucumber"

module Briar
  module Control
    module Segmented_Control
      def index_of_control_with_name (control_name)
        controls = query("segmentedControl", :accessibilityIdentifier)
        controls.index(control_name)
      end

      def index_of_segment_with_name_in_control_with_name(segment_name, control_name)
        control_idx = index_of_control_with_name (control_name)
        if control_idx
          titles = query("segmentedControl index:#{control_idx} child segment child segmentLabel", :text).reverse
          titles.index(segment_name)
        else
          nil
        end
      end
    end
  end
end
