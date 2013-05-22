#require 'calabash-cucumber'

module Briar
  module Table
    def query_str_row_in_table (row_id, table_id = nil)
      table_id == nil ?
            "tableViewCell marked:'#{row_id}'" :
            "tableView marked:'#{table_id}' child tableViewCell marked:'#{row_id}'"
    end

    def query_str_rows_in_table (table_id = nil)
      table_id == nil ?
            'tableViewCell' :
            "tableView marked:'#{table_id}' child tableViewCell"
    end

    def query_str_table (table_id = nil)
      table_id == nil ?
            'tableView' :
            "tableView marked:'#{table_id}'"
    end

    def table_has_calabash_additions
      success_value = '1'
      res = query('tableView', [{hasCalabashAdditions:success_value}])
      screenshot_and_raise 'table is not visible' if res.empty?
      res.first.eql? success_value
    end

    #noinspection RubyUnusedLocalVariable
    def row_exists? (row_id, table_id = nil)
      pending "deprecated 0.0.8 - use 'row_visible?' instead"
    end

    def row_visible? (row_id, table_id = nil)
      query_str = query_str_row_in_table row_id, table_id
      exists = !query(query_str, :accessibilityIdentifier).empty?
      # if row cannot be found just return false
      return false unless exists

      all_rows = query(query_str_rows_in_table(table_id), :accessibilityIdentifier)
      index = all_rows.index(row_id)

      # problems only happen if we are dealing with the first or last index
      return exists if index != 0 and  index != (all_rows.length - 1)

      if index == 0 or index == (all_rows.length - 1)
        # collect information about the table, row, and content offset
        content_offset_y = query('tableView', :contentOffset).first['Y']
        frame = query(query_str).first['frame']
        cell_h = frame['height'].to_f
        cell_y = frame['y'].to_f
        table_h = query(query_str_table(table_id)).first['frame']['height']

        # if the row is the first row and there has been no scrolling, just return true
        return true if index == 0 and content_offset_y == 0
        # if the row is the first row and more than half of it is visible
        return (content_offset_y + cell_y + (cell_h/2.0))/content_offset_y >= 2.0 if index == 0
        # if the row is the last row and more than half of it is visible
        return (table_h - (cell_y - content_offset_y))/(cell_h/2.0) >= 1.0 if index == (all_rows.length - 1)
      end
    end

    def should_see_row (row_id, table_id = nil)
      unless row_visible? row_id, table_id
        screenshot_and_raise "i do not see a row named #{row_id}"
      end
    end


    def should_not_see_row(row_id)
      if row_visible? row_id
        screenshot_and_raise "i should not have seen row named #{row_id}"
      end
    end

    def query_str_for_label_and_text_exists (row_id, label_id, table_id = nil)
      table_id == nil ?
            "tableViewCell marked:'#{row_id}' isHidden:0 descendant label marked:'#{label_id}'" :
            "tableView marked:'#{table_id}' child tableViewCell marked:'#{row_id}' isHidden:0 descendant label marked:'#{label_id}'"

    end

    def row_with_label_and_text_exists? (row_id, label_id, text, table_id = nil)
      should_see_row row_id
      arr = query(query_str_for_label_and_text_exists(row_id, label_id, table_id),  :text)
      (arr.length == 1) and (arr.first.eql? text)
    end

    def should_see_row_with_label_with_text (row_id, label_id, text)
      should_see_row row_id
      unless row_with_label_and_text_exists? row_id, label_id, text
        actual = query("tableViewCell marked:'#{row_id}' child tableViewCellContentView child label marked:'#{label_id}'", :text).first
        screenshot_and_raise "expected to see row '#{row_id}' with label '#{label_id}' that has text '#{text}', but found '#{actual}'"
      end
    end

    def should_see_row_with_image (row_id, image_id, table_id = nil)
      should_see_row row_id, table_id
      query_base = query_str_row_in_table row_id, table_id
      query_str = "#{query_base} child tableViewCellContentView child imageView marked:'#{image_id}'"
      if query(query_str).empty?
        if table_id == nil
          screenshot_and_raise "expected to see row '#{row_id}' with image view '#{image_id}'"
        else
          screenshot_and_raise "expected to see row '#{row_id}' with image view '#{image_id}' in table '#{table_id}'"
        end
      end
    end


    def scroll_until_i_see_row (dir, row_id, table_id=nil)
      if table_has_calabash_additions
        success = '1'
        query_str = query_str_table table_id
        res = query(query_str, [{scrollToRowWithIdenifier:row_id,
                             successValue:success}])
        unless res.eql? success
          screenshot_and_raise "should be able to scroll to row with id '#{row_id}' but the row does not exist in '#{query_str}'"
        end
      else
        wait_poll({:until_exists => "tableView descendant tableViewCell marked:'#{row_id}'",
                   :timeout => 2}) do
          scroll('tableView', dir)
        end

        unless row_visible?(row_id)
          screenshot_and_raise "i scrolled '#{dir}' but did not see '#{row_id}'"
        end
      end
    end


    def touch_row_offset_hash (row_id, table_id = nil)
      offset = 0
      query = query_str_row_in_table row_id, table_id
      if tabbar_visible?
        #puts "tabbar visible"
        cells = query(query_str_rows_in_table, :accessibilityIdentifier)
        #puts "cells = #{cells} is #{row_id} last? ==> #{cells.last.eql?(row_id)}"
        if cells.last.eql?(row_id)
          row_h = query(query, :frame).first['Height'].to_i
          offset = -1 * (row_h/3)
          #puts "offset = #{offset}"
        end
      end
      {:x => 0, :y => offset}
    end

    def touch_row (row_id, table_id = nil)
      should_see_row row_id
      offset = touch_row_offset_hash row_id, table_id
      query_str = query_str_row_in_table(row_id, table_id)
      #puts "touch(\"#{query_str}\", :offset => #{offset})"
      touch(query_str, :offset => offset)
      step_pause
    end


    def touch_row_and_wait_to_see(row_id, view, table_id = nil)
      should_see_row row_id
      touch_row row_id, table_id
      wait_for_transition("view marked:'#{view}'",
                          {:timeout=>TOUCH_TRANSITION_TIMEOUT,
                           :retry_frequency=>TOUCH_TRANSITION_RETRY_FREQ})
    end

    def table_exists? (table_name)
      !query("tableView marked:'#{table_name}'", :accessibilityIdentifier).empty?
    end

    def should_see_table (table_name)
      res = table_exists? table_name
      unless res
        screenshot_and_raise "could not find table with access id #{table_name}"
      end
    end

    def should_not_see_table (table_name)
      res = table_exists? table_name
      if res
        screenshot_and_raise "expected not to find table with access id #{table_name}"
      end
    end

    def swipe_on_row (dir, row_name)
      swipe(dir, {:query => "tableViewCell marked:'#{row_name}'"})
      step_pause
      @row_that_was_swiped = row_name
    end

    def should_not_see_delete_confirmation_in_row(row_name)
      unless query("tableViewCell marked:'#{row_name}' child tableViewCellDeleteConfirmationControl").empty?
        screenshot_and_raise "should see a delete confirmation button on row #{row_name}"
      end
    end


    def should_see_delete_confirmation_in_row(row_name)
      if query("tableViewCell marked:'#{row_name}' child tableViewCellDeleteConfirmationControl").empty?
        screenshot_and_raise "should see a delete confirmation button on row '#{row_name}'"
      end
    end

    def touch_delete_confirmation(row_name)
      touch("tableViewCell marked:'#{row_name}' child tableViewCellDeleteConfirmationControl")
      step_pause
    end

    def edit_mode_delete_button_exists? (row_name)
      #!query("tableViewCell marked:'#{row_name}' child tableViewCellEditControl").empty?
      !query("all tableViewCell marked:'#{row_name}' child tableViewCellEditControl").empty?
    end

    def should_see_edit_mode_delete_button (row_name)
      unless edit_mode_delete_button_exists? row_name
        screenshot_and_raise "should see a edit mode delete button on row #{row_name}"
      end
    end

    def should_not_see_edit_mode_delete_button (row_name)
      if edit_mode_delete_button_exists? row_name
        screenshot_and_raise "i should not see an edit mode delete button on row #{row_name}"
      end
    end

    def reorder_button_exists? (row_name)
      #TableViewCellReorderControl
      #!query("tableViewCell marked:'#{row_name}' child tableViewCellReorderControl").empty?
      !query("all tableViewCell marked:'#{row_name}' child tableViewCellReorderControl").empty?
    end

    def should_see_reorder_button (row_name)
      unless reorder_button_exists? row_name
        screenshot_and_raise "i should be able to see reorder button on row #{row_name}"
      end
    end

    def should_not_see_reorder_button (row_name)
      if reorder_button_exists? row_name
        screenshot_and_raise "i should not see reorder button on row #{row_name}"
      end
    end

  end
end
