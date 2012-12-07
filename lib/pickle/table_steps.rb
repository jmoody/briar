
def query_str_row_in_table (row_id, table_id = nil)
  table_id == nil ?
        "tableViewCell marked:'#{row_id}'" :
        "tableView marked:'#{table_id}' child tableViewCell marked:'#{row_id}'"
end

def query_str_rows_in_table (table_id = nil)
  table_id == nil ?
        "tableViewCell" :
        "tableView marked:'#{table_id}' child tableViewCell"
end

def query_str_table (table_id = nil)
  table_id == nil ?
        "tableView" :
        "tableView marked:'#{table_id}'"
end

def row_exists? (row_id, table_id = nil)
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
    content_offset_y = query("tableView", :contentOffset).first["Y"]
    frame = query(query_str).first["frame"]
    cell_h = frame["height"].to_f
    cell_y = frame["y"].to_f
    table_h = query(query_str_table(table_id)).first["frame"]["height"]

    # if the row is the first row and there has been no scrolling, just return true
    return true if index == 0 and content_offset_y == 0
    # if the row is the first row and more than half of it is visible
    return (content_offset_y + cell_y + (cell_h/2.0))/content_offset_y >= 2.0 if index == 0
    # if the row is the last row and more than half of it is visible
    return (table_h - (cell_y - content_offset_y))/(cell_h/2.0) >= 1.0 if index == (all_rows.length - 1)
  end
end

def should_see_row (row_id, table_id = nil)
  unless row_exists? row_id, table_id
    screenshot_and_raise "i do not see a row named #{row_id}"
  end
end

Then /^I should see (?:the|an?) "([^"]*)" row$/ do |name|
  should_see_row name
end


def should_not_see_row(row_id)
  if row_exists? row_id
    screenshot_and_raise "i should not have seen row named #{row_id}"
  end
end

def row_with_label_and_text_exists? (row_id, label_id, text)
  should_see_row row_id
  arr = query("tableViewCell marked:'#{row_id}' child tableViewCellContentView child label marked:'#{label_id}'", :text)
  # iOS 4 and 5
  return true if (arr.length == 1) and (arr.first.eql? text)
  # iOS 6
  if arr.length > 1
    puts "iOS 6 can have duplicate subviews"
    arr.member?(text)
  end
end


def should_see_row_with_label_with_text (row_id, label_id, text)
  should_see_row row_id
  unless row_with_label_and_text_exists? row_id, label_id, text
    actual = query("tableViewCell marked:'#{row_id}' child tableViewCellContentView child label marked:'#{label_id}'", :text).first
    screenshot_and_raise "expected to see row '#{row_id}' with label '#{label_id}' that has text '#{text}', but found '#{actual}'"
  end
end


def scroll_until_i_see_row (dir, row_id, limit)
  unless row_exists? row_id
     count = 0
     begin
       scroll("scrollView index:0", dir)
       step_pause
       count = count + 1
     end while ((not row_exists?(row_id)) and count < limit.to_i)
   end
   unless row_exists?(row_id)
     screenshot_and_raise "i scrolled '#{dir}' '#{limit}' times but did not see '#{row_id}'"
   end
end


Then /^I scroll (left|right|up|down) until I see the "([^\"]*)" row limit (\d+)$/ do |dir, row_name, limit|
  scroll_until_i_see_row dir, row_name, limit
end


def touch_row_offset_hash (row_id, table_id = nil)
  offset = 0
  query = query_str_row_in_table row_id, table_id
  if tabbar_visible?
    puts "tabbar visible"
    cells = query(query_str_rows_in_table, :accessibilityIdentifier)
    puts "cells = #{cells} is #{row_id} last? ==> #{cells.last.eql?(row_id)}"
    if cells.last.eql?(row_id)
    row_h = query(query, :frame).first["Height"].to_i
    offset = -1 * (row_h/3)
    puts "offset = #{offset}"
    end
  end
  {:x => 0, :y => offset}
end

def touch_row (row_id, table_id = nil)
  should_see_row row_id
  offset = touch_row_offset_hash row_id, table_id
  query_str = query_str_row_in_table(row_id, table_id)
  puts "touch(\"#{query_str}\", :offset => #{offset})"
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


Then /^I touch (?:the) "([^"]*)" row and wait for (?:the) "([^"]*)" (?:view) to appear$/ do |row_id, view_id|
  # problem
  wait_for_animation
  touch_row_and_wait_to_see row_id, view_id
end

Then /^I touch the "([^"]*)" row on the "([^"]*)" table and wait for the "([^"]*)" view to appear$/ do |row_id, table_id, view_id|
  wait_for_animation
  touch_row_and_wait_to_see row_id, view_id, table_id
end


Then /^I touch (?:the) "([^"]*)" row$/ do |row_name|
  touch_row row_name
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

Then /^I touch the "([^"]*)" section header$/ do |header_name|
  touch("tableView child view marked:'#{header_name}'")
  wait_for_animation
end

Then /^I should see the "([^"]*)" table in edit mode$/ do |table_id|
  unless query("tableView marked:'#{table_id}'", :isEditing).first.to_i == 1
    screenshot_and_raise "expected to see table '#{table_id}' in edit mode"
  end
end


Then /^the (first|second) row should be "([^"]*)"$/ do |idx, row_id|
  (idx.eql? "first") ? index = 0 : index = 1
  res = query("tableViewCell", :accessibilityIdentifier)[index]
  unless res.eql? row_id
    screenshot_and_raise "i expected the #{idx} row would be #{row_id}, but found #{res}"
  end
end


def swipe_on_row (dir, row_name)
  swipe(dir, {:query => "tableViewCell marked:'#{row_name}'"})
  step_pause
  @row_that_was_swiped = row_name
end

Then /^I swipe (left|right) on the "([^"]*)" row$/ do |dir, row_name|
  swipe_on_row dir, row_name
end

def should_not_see_delete_confirmation_in_row(row_name)
  unless query("tableViewCell marked:'#{row_name}' child tableViewCellDeleteConfirmationControl").empty?
    screenshot_and_raise "should see a delete confirmation button on row #{row_name}"
  end
end


def should_see_delete_confirmation_in_row(row_name)
  if query("tableViewCell marked:'#{row_name}' child tableViewCellDeleteConfirmationControl").empty?
    screenshot_and_raise "should see a delete confirmation button on row #{row_name}"
  end
end

def touch_delete_confirmation(row_name)
  touch("tableViewCell marked:'#{row_name}' child tableViewCellDeleteConfirmationControl")
  step_pause
end

def edit_mode_delete_button_exists? (row_name)
  #!query("tableViewCell marked:'#{row_name}' child tableViewCellEditControl").empty?
  !query_all("tableViewCell marked:'#{row_name}' child tableViewCellEditControl").empty?
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
  !query_all("tableViewCell marked:'#{row_name}' child tableViewCellReorderControl").empty?
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

Then /^I should be able to swipe to delete the "([^"]*)" row$/ do |row_name|
  swipe_on_row "left", row_name
  should_see_delete_confirmation_in_row row_name
  touch_delete_confirmation row_name
  should_not_see_row row_name
end

Then /^I touch the delete button on the "([^"]*)" row$/ do |row_name|
  should_see_edit_mode_delete_button row_name
  touch("tableViewCell marked:'#{row_name}' child tableViewCellEditControl")
  step_pause
  should_see_delete_confirmation_in_row row_name
end

Then /^I use the edit mode delete button to delete the "([^"]*)" row$/ do |row_name|
  macro %Q|I touch the delete button on the "#{row_name}" row|
  touch_delete_confirmation row_name
  should_not_see_row row_name
end

Then /^I should see "([^"]*)" in row (\d+)$/ do |cell_name, row|
  # on ios 6 this is returning nil
  #res = query("tableViewCell index:#{row}", :accessibilityIdentifier).first
  access_ids = query("tableViewCell", :accessibilityIdentifier)
  unless access_ids.index(cell_name) == row.to_i
    screenshot_and_raise "expected to see '#{cell_name}' in row #{row} but found '#{access_ids[row.to_i]}'"
  end
end

Then /^I should see the rows in this order "([^"]*)"$/ do |row_ids|
  tokens = row_ids.split(",")
  counter = 0
  tokens.each do |token|
    token.strip!
    macro %Q|I should see "#{token}" in row #{counter}|
    counter = counter + 1
  end
end

Then /^I should see that the "([^"]*)" row has text "([^"]*)" in the "([^"]*)" label$/ do |row_id, text, label_id|
  should_see_row_with_label_with_text row_id, label_id, text
end

Then /^I should see that the text I just entered is in the "([^"]*)" row "([^"]*)" label$/ do |row_id, label_id|
  should_see_row_with_label_with_text row_id, label_id, @text_entered_by_keyboard
end

Then /^I move the "([^"]*)" row (up|down) (\d+) times? using the reorder edit control$/ do |row_id, dir, n|
  should_see_row row_id
  dir_str = (dir.eql?("up")) ? "drag_row_up" : "drag_row_down"
  n.to_i.times do (
  playback(dir_str,
           {:query => "tableViewCell marked:'#{row_id}' descendant tableViewCellReorderControl"})
  step_pause)
  end
end

Then /^I should (see|not see) (?:the|an?) "([^"]*)" table$/ do |visibility, table_id|
  if visibility.eql?("see")
    should_see_table table_id
  else
    should_not_see_table table_id
  end
end

Then /^I should see a "([^"]*)" button in the "([^"]*)" row$/ do |button_id, row_id|
  should_see_row row_id
  arr = query("tableViewCell marked:'#{row_id}' child tableViewCellContentView child button marked:'#{button_id}'", :accessibilityIdentifier)
  (arr.length == 1)
end

Then /^I touch the "([^"]*)" button in the "([^"]*)" row$/ do |button_id, row_id|
  should_see_row row_id
  touch("tableViewCell marked:'#{row_id}' child tableViewCellContentView child button marked:'#{button_id}'")
end

Then /^I should see a switch for "([^"]*)" in the "([^"]*)" row that is in the "([^"]*)" position$/ do |switch_id, row_id, on_off|
  should_see_row row_id
  query_str = "tableViewCell marked:'#{row_id}' child tableViewCellContentView child switch marked:'#{switch_id}'"
  res = query(query_str, :isOn).first
  unless res
    screenshot_and_raise "expected to find a switch marked '#{switch_id}' in row '#{row_id}'"
  end
  expected = (on_off.eql? "on") ? 1 : 0
  unless res.to_i == expected
    screenshot_and_raise "expected to find a switch marked '#{switch_id}' in row '#{row_id}' that is '#{on_off}' but found it was '#{res ? "on" : "off"}'"
  end
end

Then /^I should see a detail disclosure chevron in the "([^"]*)" row$/ do |row_id|
    should_see_row row_id
  # gray disclosure chevron is accessory type 1
  res = query("tableViewCell marked:'#{row_id}'", :accessoryType).first
  unless res == 1
    screenshot_and_raise "expected to see disclosure chevron in row '#{row_id}' but found '#{res}'"
  end
end

Then /^I touch the "([^"]*)" switch in the "([^"]*)" row$/ do |switch_id, row_id|
  should_see_row row_id
  touch("tableViewCell marked:'#{row_id}' child tableViewCellContentView child switch marked:'#{switch_id}'")
end

Then /^I should see "([^"]*)" in the "([^"]*)" section (footer|header)$/ do |text, section_footer_id, head_or_foot|
  res = query("tableView child view marked:'#{section_footer_id} section #{head_or_foot}' child label", :text).first
  unless res.eql? text
    screenshot_and_raise "expected to see '#{text}' in the '#{section_footer_id}' section #{head_or_foot} but found '#{res}'"
  end
end

Then /^I should see a text field with text "([^"]*)" in the "([^"]*)" row$/ do |text, row_id|
  should_see_row row_id
  query_str = "tableViewCell marked:'#{row_id}' child tableViewCellContentView child textField"
  res = query(query_str)
  screenshot_and_raise "expected to see text field in '#{row_id}' row" if res.empty?
  actual = query(query_str, :text).first
  screenshot_and_raise "expected to find text field with '#{text}' in row '#{row_id}' but found '#{actual}'" if !text.eql? actual
end

When /^I touch the "([^"]*)" text field in the "([^"]*)" row the keyboard appears$/ do |text_field_id, row_id|
  should_see_row row_id
  query_str = "tableViewCell marked:'#{row_id}' child tableViewCellContentView child textField marked:'#{text_field_id}'"
  touch(query_str)
  wait_for_animation
  should_see_keyboard
end
