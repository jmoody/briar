#include Briar::Table
#include Briar::Core

Then /^I should see (?:the|an?) "([^"]*)" row$/ do |name|
  should_see_row name
end

Then /^I scroll (left|right|up|down) until I see the "([^\"]*)" row limit (\d+)$/ do |dir, row_name, limit|
  scroll_until_i_see_row dir, row_name, limit
end


Then /^I touch (?:the) "([^"]*)" row and wait for (?:the) "([^"]*)" view to appear$/ do |row_id, view_id|
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


Then /^I swipe (left|right) on the "([^"]*)" row$/ do |dir, row_name|
  swipe_on_row dir, row_name
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


Then /^I should see that the "([^"]*)" row has image "([^"]*)"$/ do |row_id, image_id|
  should_see_row_with_image row_id, image_id
end
