#require 'calabash-cucumber'

module Briar
  module Table

    def query_str_for_row_content (row_id, table_id = nil)
      base = query_str_for_row row_id, table_id
      "#{base} tableViewCellContentView descendant"
    end

    def query_str_for_row (row_id, table_id = nil)
      table_id == nil ?
            "tableViewCell marked:'#{row_id}'" :
            "tableView marked:'#{table_id}' descendant tableViewCell marked:'#{row_id}'"
    end

    def query_str_for_rows (table_id = nil)
      table_id == nil ?
            'tableViewCell' :
            "tableView marked:'#{table_id}' descendant tableViewCell"
    end

    def query_str_for_table (table_id = nil)
      table_id == nil ?
            'tableView' :
            "tableView marked:'#{table_id}'"
    end

    def table_has_calabash_additions
      success_value = '1'
      res = query('tableView', [{hasCalabashAdditions: success_value}])
      screenshot_and_raise 'table is not visible' if res.empty?
      res.first.eql? success_value
    end

    #noinspection RubyUnusedLocalVariable
    def row_exists? (row_id, table_id = nil)
      pending "deprecated 0.0.8 - use 'row_visible?' instead"
    end

    def row_visible? (row_id, table_id = nil)
      query_str = query_str_for_row row_id, table_id
      !query(query_str, AI).empty?

      #query_str = query_str_row_in_table row_id, table_id
      #exists = !query(query_str, AI).empty?
      ## if row cannot be found just return false
      #return false unless exists
      #
      #all_rows = query(query_str_rows_in_table(table_id), AI)
      #index = all_rows.index(row_id)
      #
      ## problems only happen if we are dealing with the first or last index
      #return exists if index != 0 and  index != (all_rows.length - 1)
      #
      #if index == 0 or index == (all_rows.length - 1)
      #  # collect information about the table, row, and content offset
      #  content_offset_y = query('tableView', :contentOffset).first['Y']
      #  frame = query(query_str).first['frame']
      #  cell_h = frame['height'].to_f
      #  cell_y = frame['y'].to_f
      #  table_h = query(query_str_table(table_id)).first['frame']['height']
      #
      #  # if the row is the first row and there has been no scrolling, just return true
      #  return true if index == 0 and content_offset_y == 0
      #  # if the row is the first row and more than half of it is visible
      #  return (content_offset_y + cell_y + (cell_h/2.0))/content_offset_y >= 2.0 if index == 0
      #  # if the row is the last row and more than half of it is visible
      #  return (table_h - (cell_y - content_offset_y))/(cell_h/2.0) >= 1.0 if index == (all_rows.length - 1)
      #end
    end

    def should_see_row (row_id, table_id = nil)
      unless row_visible? row_id, table_id
        screenshot_and_raise "i do not see a row '#{row_id}'"
      end
    end


    def should_not_see_row(row_id, table_id=nil)
      if row_visible? row_id, table_id
        screenshot_and_raise "i should not have seen row named #{row_id}"
      end
    end

    def wait_for_row(row_id, options={:table_id => nil,
                                      :timeout => 1.0})
      table_id = options[:table_id]
      query_str = query_str_for_row row_id, table_id
      timeout = options[:timeout] || 1.0
      msg = "waited for '#{timeout}' seconds but did not see row '#{query_str}' with query '#{query_str}'"
      wait_for(:timeout => timeout,
               :retry_frequency => 0.2,
               :post_timeout => 0.1,
               :timeout_message => msg ) do
        row_visible? row_id, table_id
      end
    end


    def query_str_for_label_and_text_exists (row_id, label_id, table_id = nil)
      query_str = query_str_for_row_content row_id, table_id
      "#{query_str} label marked:'#{label_id}'"
    end

    def row_with_label_and_text_exists? (row_id, label_id, text, table_id = nil)
      should_see_row row_id
      arr = query(query_str_for_label_and_text_exists(row_id, label_id, table_id), :text)
      (arr.length == 1) and (arr.first.eql? text)
    end

    def should_see_row_with_label_with_text (row_id, label_id, text, table_id=nil)
      should_see_row row_id, table_id
      unless row_with_label_and_text_exists? row_id, label_id, text, table_id
        query_str = query_str_for_row_content row_id, table_id
        actual = query("#{query_str} label marked:'#{label_id}'", :text).first
        screenshot_and_raise "expected to see row '#{row_id}' with label '#{label_id}' that has text '#{text}', but found '#{actual}'"
      end
    end

    def should_see_row_with_image (row_id, image_id, table_id = nil)
      should_see_row row_id, table_id
      query_str = query_str_for_row_content row_id, table_id
      if query("#{query_str} imageView marked:'#{image_id}'").empty?
        if table_id == nil
          screenshot_and_raise "expected to see row '#{row_id}' with image view '#{image_id}'"
        else
          screenshot_and_raise "expected to see row '#{row_id}' with image view '#{image_id}' in table '#{table_id}'"
        end
      end
    end

    def briar_additions_scroll_to_row_with_id (row_id, table_id=nil)
      warn 'this was included by mistake in the release - do not use it'
      unless table_id.nil?
        should_see_table row_id
      end

      unless table_has_calabash_additions
        screenshot_and_raise "this method requires a category on UITableView that implements selector 'scrollToRowWithIdentifier:successValue' - use 'scroll_until_i_see_row' instead"
      end
      query_str = query_str_for_table table_id
      res = query(query_str, [{scrollToToRowWithIdentifier: row_id}]).first

      step_pause
      unless res.eql? row_id
        screenshot_and_raise "should be able to scroll to row with id '#{row_id}' but the row does not exist in '#{query_str}' - server returned '#{res}'"
      end
    end

    def scroll_to_row_with_mark(row_id, options={:query => 'tableView',
                                                 :scroll_position => :middle,
                                                 :animate => true})
      uiquery = options[:query] || 'tableView'

      args = []
      if options.has_key?(:scroll_position)
        args << options[:scroll_position]
      else
        args << 'middle'
      end
      if options.has_key?(:animate)
        args << options[:animate]
      end

      views_touched=map(uiquery, :scrollToRowWithMark, row_id, *args)

      if views_touched.empty? or views_touched.member? '<VOID>'
        msg = options[:failed_message] || "Unable to scroll: '#{uiquery}' to: #{options}"
        screenshot_and_raise msg
      end
      views_touched
    end

    def briar_scroll_to_row (row_id, table_id=nil)
      unless table_id.nil?
        should_see_table row_id
      end

      query_str = query_str_for_table table_id

      msg = "could find row marked '#{row_id}' in table '#{query_str}'"
      options = {:query => query_str,
                 :scroll_position => :middle,
                 :animate => true,
                 :failed_message => msg}
      scroll_to_row_with_mark row_id, options
      # you will be tempted to remove this pause - don't.
      # remove the animation instead
      step_pause
    end

    def briar_scroll_to_row_and_touch (row_id, wait_for_view=nil)
      briar_scroll_to_row(row_id)
      if wait_for_view.nil?
        touch_row row_id
      else
        touch_row_and_wait_to_see row_id, wait_for_view
      end
    end

    def scroll_until_i_see_row (dir, row_id, table_id=nil)
      warn "deprecated 0.0.8 - use 'scroll_to_row #{row_id}' with optional table view mark"
      wait_poll({:until_exists => query_str_for_row(row_id, table_id),
                 :timeout => 2}) do
        scroll('tableView', dir)
      end

      unless row_visible?(row_id)
        screenshot_and_raise "i scrolled '#{dir}' but did not see '#{row_id}'"
      end
    end


    def touch_row_offset_hash (row_id, table_id = nil)
      offset = 0
      query = query_str_for_row row_id, table_id
      if tabbar_visible?
        #puts "tabbar visible"
        cells = query(query_str_for_rows, AI)
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
      query_str = query_str_for_row(row_id, table_id)
      #puts "touch(\"#{query_str}\", :offset => #{offset})"
      touch(query_str, :offset => offset)
      step_pause
    end


    def touch_row_and_wait_to_see(row_id, view, table_id = nil)
      should_see_row row_id, table_id
      touch_row row_id, table_id
      wait_for_transition("view marked:'#{view}'",
                          {:timeout => TOUCH_TRANSITION_TIMEOUT,
                           :retry_frequency => TOUCH_TRANSITION_RETRY_FREQ})
    end

    def table_exists? (table_name)
      !query("tableView marked:'#{table_name}'", AI).empty?
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

    def swipe_on_row (dir, row_id, table_id=nil)
      query_str = query_str_for_row row_id, table_id
      swipe(dir, {:query => query_str})
      step_pause
      @row_that_was_swiped = row_id
    end


    def should_not_see_delete_confirmation_in_row(row_id, table_id=nil)
      query_str = query_str_for_row row_id, table_id
      unless query("#{query_str} descendant tableViewCellDeleteConfirmationControl").empty?
        screenshot_and_raise "should see a delete confirmation button on row #{row_id}"
      end
    end

    def should_see_delete_confirmation_in_row(row_id, table_id=nil)
      query_str = query_str_for_row row_id, table_id
      if query("#{query_str} descendant tableViewCellDeleteConfirmationControl").empty?
        screenshot_and_raise "should see a delete confirmation button on row '#{row_id}'"
      end
    end

    def touch_delete_confirmation(row_id, table_id=nil)
      query_str = query_str_for_row row_id, table_id
      touch("#{query_str} descendant tableViewCellDeleteConfirmationControl")
      step_pause
    end

    def edit_mode_delete_button_exists? (row_id, table_id=nil)
      query_str = query_str_for_row row_id, table_id
      #!query("all tableViewCell marked:'#{row_id}' child tableViewCellEditControl").empty?
      !query("#{query_str} descendant tableViewCellEditControl").empty?
    end

    def should_see_edit_mode_delete_button (row_id, table_id=nil)
      unless edit_mode_delete_button_exists? row_id, table_id
        screenshot_and_raise "should see a edit mode delete button on row #{row_id}"
      end
    end

    def should_not_see_edit_mode_delete_button (row_id, table_id=nil)
      if edit_mode_delete_button_exists? row_id, table_id
        screenshot_and_raise "i should not see an edit mode delete button on row #{row_id}"
      end
    end

    def reorder_button_exists? (row_id, table_id=nil)
      query_str = query_str_for_row row_id, table_id
      #!query("tableViewCell marked:'#{row_id}' child tableViewCellReorderControl").empty?
      #!query("all tableViewCell marked:'#{row_id}' child tableViewCellReorderControl").empty?
      !query("#{query_str} descendant tableViewCellReorderControl").empty?
    end

    def should_see_reorder_button (row_id, table_id=nil)
      unless reorder_button_exists? row_id, table_id
        screenshot_and_raise "i should be able to see reorder button on row #{row_id}"
      end
    end

    def should_not_see_reorder_button (row_id, table_id=nil)
      if reorder_button_exists? row_id, table_id
        screenshot_and_raise "i should not see reorder button on row #{row_id}"
      end
    end

    def should_see_row_at_index (row_id, index, table_id=nil)
      query_str = query_str_for_rows table_id
      res = query(query_str, AI)[index.to_i]
      unless res.eql? row_id
        screenshot_and_raise "i should see '#{row_id}' at #{index} in '#{query_str}', but found #{res}"
      end
    end

    def touch_edit_mode_delete_button (row_id, table_id=nil)
      should_see_edit_mode_delete_button row_id, table_id
      touch("tableViewCell marked:'#{row_id}' child tableViewCellEditControl")
      step_pause
      should_see_delete_confirmation_in_row row_id
    end

    def should_see_switch_in_row_with_state (switch_id, row_id, state, table_id=nil)
      should_see_row row_id, table_id
      query_str = query_str_for_row_content row_id, table_id
      res = query("#{query_str} switch marked:'#{switch_id}'", :isOn).first
      unless res
        screenshot_and_raise "expected to find a switch marked '#{switch_id}' in row '#{row_id}'"
      end
      unless res.to_i == state
        screenshot_and_raise "expected to find a switch marked '#{switch_id}' in row '#{row_id}' that is '#{state ? 'on' : 'off'}' but found it was '#{res ? 'on' : 'off'}'"
      end
    end

    def touch_text_field_clear_button_in_row (row_id, table_id=nil)
      query_str = query_str_for_row_content row_id, table_id
      res = query("#{query_str} textField")
      screenshot_and_raise "expected to see text field in '#{row_id}' row" if res.empty?
      touch("#{query_str} textField descendant button")
      step_pause
    end

    def touch_text_field_in_row_and_wait_for_keyboard (text_field_id, row_id, table_id=nil)
      should_see_row row_id, table_id
      query_str = query_str_for_row_content row_id, table_id
      touch("#{query_str} textField marked:'#{text_field_id}'")
      step_pause
      should_see_keyboard
    end

    def should_see_text_field_in_row_with_text (row_id, text_field_id, text, table_id=nil)
      should_see_row row_id, table_id
      query_str = "#{query_str_for_row_content row_id, table_id} textField marked:'#{text_field_id}'"
      res = query(query_str)
      screenshot_and_raise "expected to see text field in '#{row_id}' row" if res.empty?
      actual = query(query_str, :text).first
      screenshot_and_raise "expected to find text field with '#{text}' in row '#{row_id}' but found '#{actual}'" if !text.eql? actual
    end

    def delete_row_with_edit_mode_delete_button (row_id, table_id=nil)
      touch_edit_mode_delete_button row_id, table_id
      touch_delete_confirmation row_id, table_id
      should_not_see_row row_id, table_id
    end

    def touch_switch_in_row (switch_id, row_id, table_id=nil)
      should_see_row row_id, table_id
      query_str = query_str_for_row_content row_id, table_id
      touch("#{query_str} switch marked:'#{switch_id}'")
      step_pause
    end

    def swipe_to_delete_row (row_id, table_id = nil)
      swipe_on_row 'left', row_id, table_id
      should_see_delete_confirmation_in_row row_id, table_id
      touch_delete_confirmation row_id, table_id
      should_not_see_row row_id, table_id
    end

    def should_see_disclosure_chevron_in_row (row_id, table_id=nil)
      should_see_row row_id, table_id
      # gray disclosure chevron is accessory type 1
      query_str = query_str_for_row row_id, table_id
      res = query(query_str, :accessoryType).first
      unless res == 1
        screenshot_and_raise "expected to see disclosure chevron in row '#{row_id}' but found '#{res}'"
      end
    end

    def should_see_slider_in_row (slider_id, row_id, table_id)
      query_str = query_str_for_row_content row_id, table_id
      actual_id = query("#{query_str} slider marked:'#{slider_id}'", AI).first
      unless actual_id.eql? row_id
        screenshot_and_raise "expected to see slider '#{slider_id}' in '#{row_id}' but found '#{actual_id}'"
      end
    end

    def should_see_slider_in_row_with_value (slider_id, row_id, value, table_id=nil)
      query_str = query_str_for_row_content row_id, table_id
      actual_value = query("#{query_str} slider marked:'#{slider_id}'", :value).first.to_i
      unless actual_value == value.to_i
        screenshot_and_raise "expected to see slider '#{slider_id}' with '#{value}' in '#{row_id}' but found '#{actual_value}'"
      end
    end

    def touch_section_header (header_id, table_id=nil)
      query_str = query_str_for_table table_id
      touch("#{query_str} descendant view marked:'#{header_id}'")
      step_pause
    end
  end
end
