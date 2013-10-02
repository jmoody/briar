Then /^I should see (?:the|an?) "([^"]*)" row$/ do |name|
  should_see_row name
end


Then(/^I scroll to the "([^"]*)" row$/) do |row_id|
  briar_scroll_to_row row_id
end

#noinspection RubyUnusedLocalVariable
Then /^I scroll (left|right|up|down) until I see the "([^\"]*)" row limit (\d+)$/ do |dir, row_id, limit|
  pending "deprecated 0.0.6 - use 'Then I scroll to the \"#{row_id}\" row'"
end


#noinspection RubyUnusedLocalVariable
Then /^I scroll (left|right|up|down) until I see (?:the|an?) "([^\"]*)" row$/ do |dir, row_id|
  pending "deprecated 0.0.8 - use 'Then I scroll to the \"#{row_id}\" row'"
end

Then /^I touch (?:the) "([^"]*)" row and wait for (?:the) "([^"]*)" view to appear$/ do |row_id, view_id|
  wait_for_row row_id
  step_pause
  touch_row_and_wait_to_see row_id, view_id
end

Then /^I touch the "([^"]*)" row on the "([^"]*)" table and wait for the "([^"]*)" view to appear$/ do |row_id, table_id, view_id|
  wait_for_row row_id
  touch_row_and_wait_to_see row_id, view_id, table_id
end

Then /^I touch (?:the) "([^"]*)" row$/ do |row_name|
  touch_row row_name
end

Then /^I touch the "([^"]*)" section header$/ do |header_id|
  touch_section_header header_id
end

Then /^I should see the "([^"]*)" table in edit mode$/ do |table_id|
  unless query("tableView marked:'#{table_id}'", :isEditing).first.to_i == 1
    screenshot_and_raise "expected to see table '#{table_id}' in edit mode"
  end
end


Then /^the (first|second) row should be "([^"]*)"$/ do |idx, row_id|
  (idx.eql? 'first') ? index = 0 : index = 1
  should_see_row_at_index row_id, index
end

Then(/^the (\d+)(?:st|nd|rd|th)? row should be "([^"]*)"$/) do |row_index, row_id|
  idx = row_index.to_i - 1
  should_see_row_at_index row_id, idx
end

Then /^I swipe (left|right) on the "([^"]*)" row$/ do |dir, row_name|
  swipe_on_row dir, row_name
end

Then /^I should be able to swipe to delete the "([^"]*)" row$/ do |row_id|
  swipe_to_delete_row row_id
end

Then /^I touch the delete button on the "([^"]*)" row$/ do |row_id|
  touch_edit_mode_delete_button row_id
end

Then /^I use the edit mode delete button to delete the "([^"]*)" row$/ do |row_id|
  delete_row_with_edit_mode_delete_button row_id
end

Then /^I should see "([^"]*)" in row (\d+)$/ do |row_id, row_index|
  # on ios 6 this is returning nil
  #res = query("tableViewCell index:#{row}", AI).first
  should_see_row_at_index row_id, row_index
end

Then /^I should see the rows in this order "([^"]*)"$/ do |row_ids|
  tokens = row_ids.split(',')
  counter = 0
  tokens.each do |token|
    token.strip!
    should_see_row_at_index token, counter
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
  if device.ios7?
    pending 'reordering on iOS 7 (more specifically playback) is not supported'
  end

  should_see_row row_id
  dir_str = (dir.eql?('up')) ? 'drag_row_up' : 'drag_row_down'
  n.to_i.times do
    (
    playback(dir_str,
             {:query => "tableViewCell marked:'#{row_id}' descendant tableViewCellReorderControl"})
    step_pause)
  end
end

Then /^I should (see|not see) (?:the|an?) "([^"]*)" table$/ do |visibility, table_id|
  if visibility.eql?('see')
    should_see_table table_id
  else
    should_not_see_table table_id
  end
end

Then /^I should see a "([^"]*)" button in the "([^"]*)" row$/ do |button_id, row_id|
  should_see_row row_id
  arr = query("tableViewCell marked:'#{row_id}' descendant button marked:'#{button_id}'", AI)
  (arr.length == 1)
end

Then /^I touch the "([^"]*)" button in the "([^"]*)" row$/ do |button_id, row_id|
  should_see_row row_id
  touch("tableViewCell marked:'#{row_id}' descendant button marked:'#{button_id}'")
end

Then /^I should see a switch for "([^"]*)" in the "([^"]*)" row that is in the "([^"]*)" position$/ do |switch_id, row_id, on_off|
  should_see_switch_in_row_with_state switch_id, row_id, (on_off.eql? 'on') ? 1 : 0
end

Then /^I should see a detail disclosure chevron in the "([^"]*)" row$/ do |row_id|
  should_see_disclosure_chevron_in_row row_id
end

Then /^I touch the "([^"]*)" switch in the "([^"]*)" row$/ do |switch_id, row_id|
  touch_switch_in_row switch_id, row_id
end

Then /^I should see "([^"]*)" in the "([^"]*)" section (footer|header)$/ do |text, section_footer_id, head_or_foot|
  res = query("tableView child view marked:'#{section_footer_id} section #{head_or_foot}' child label", :text).first
  unless res.eql? text
    screenshot_and_raise "expected to see '#{text}' in the '#{section_footer_id}' section #{head_or_foot} but found '#{res}'"
  end
end

Then /^I should see a text field with text "([^"]*)" in the "([^"]*)" row$/ do |text, row_id|
  should_see_text_field_in_row_with_text row_id, text
end

When /^I touch the "([^"]*)" text field in the "([^"]*)" row the keyboard appears$/ do |text_field_id, row_id|
  touch_text_field_in_row_and_wait_for_keyboard text_field_id, row_id
end

Then /^I should see that the "([^"]*)" row has image "([^"]*)"$/ do |row_id, image_id|
  should_see_row_with_image row_id, image_id
end


Then(/^I should see that the "([^"]*)" row has no text in the "([^"]*)" label$/) do |row_id, label_id|
  should_see_row_with_label_that_has_no_text
end

