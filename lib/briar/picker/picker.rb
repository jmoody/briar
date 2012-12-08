require 'calabash-cucumber'

module Briar
  module Picker
    include Briar::Picker_Shared
    def should_see_picker (picker_name)
      picker_exists = !query("pickerView marked:'#{picker_name}").empty?
      unless picker_exists
        screenshot_and_raise "could not find picker named #{picker_name}"
      end
    end

    def should_not_see_picker (picker_name)
      picker_exists = !query("pickerView marked:'#{picker_name}").empty?
      if picker_exists
        screenshot_and_raise "expected to _not_ see #{picker}"
      end
    end

    def visible_titles (column)
      query("pickerTableView index:#{column} child pickerTableViewWrapperCell", :wrappedView, :text).reverse
    end

# may only work on circular pickers - does _not_ work on non-circular pickers
# because the visible titles do _not_ follow the selected index
    def selected_title_for_column (column)
      selected_idx = picker_current_index_for_column column
      titles = visible_titles column
      titles[selected_idx]
    end
  end
end
