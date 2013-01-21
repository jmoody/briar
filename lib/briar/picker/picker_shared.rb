require 'calabash-cucumber'

module Briar
  module Picker_Shared
    def picker_current_index_for_column (column)
      arr = query("pickerTableView", :selectionBarRow)
      arr[column]
    end
    # methods common to generic and date pickers
    def picker_current_index_for_column_is(column, val)
      picker_current_index_for_column(column) == val
    end

    def previous_index_for_column (column)
      picker_current_index_for_column(column) - 1
    end

    def picker_next_index_for_column (column)
      picker_current_index_for_column(column) + 1
    end

    def picker_scroll_down_on_column(column)
      new_row = previous_index_for_column column
      #scroll_to_row("pickerTableView index:#{column}", new_row)
      query("pickerTableView index:'#{column}'", [{selectRow:new_row}, {animated:1}, {notify:1}])
    end

    def picker_scroll_up_on_column(column)
      new_row = picker_next_index_for_column column
      query("pickerTableView index:'#{column}'", [{selectRow:new_row}, {animated:1}, {notify:1}])
    end
  end
end

