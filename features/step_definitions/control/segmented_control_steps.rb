
Then /^I should see segmented control "([^"]*)" with titles "([^"]*)"$/ do |control_id, titles|
  should_see_control_with_segment_titles control_id, titles
end

Then /^I touch the "([^"]*)" segment in segmented control "([^"]*)"$/ do |segment_id, control_id|
  touch_segment segment_id, control_id
end

Then /^I should see segment "([^"]*)" in segmented control "([^"]*)" (is|is not) selected$/ do |segment_id, control_id, selectedness|
  should_see_segment_with_selected_state control_id, segment_id, selectedness.eql?('is') ? 1 : 0
end


### deprecated - will remove in future versions ####

Then /^I should see the segment I touched (is|is not) selected and the "([^"]*)" should be set correctly$/ do |selectedness, label_id|
  _deprecated('0.1.1', 'no replacement', :pending)
  #@associated_label = label_id
  #should_see_segment_with_selected_state @control_id, @segment_id, selectedness.eql?('is') ? 1 : 0
  ## unexpected!
  ## this is a label outside the control that is set by touching the segment
  ## not so good because it conflates segment_id and the title of the segment
  #should_see_label_with_text label_id, @segment_id
end

Then /^I touch the segment again$/ do
  _deprecated('0.1.1', 'no replacement', :pending)
  #touch_segment @segment_id, @control_id
end

Then /^I should see the segment is not selected and the detail label is cleared$/ do
  _deprecated('0.1.1', 'no replacement', :pending)
  ## ugh - that @associated_label variable needs to be set
  #macro %Q|I should see segment "#{@segment_id}" in segmented control "#{@control_id}" is not selected|
  #macro %Q|I should see label "#{@associated_label}" with text ""|
end

Then /^I should see the segment I touched (is|is not) selected and the "([^"]*)" in the "([^"]*)" row should be set correctly$/ do |selectedness, label_id, row_id|
  _deprecated('0.1.1', 'no replacement', :pending)
  ## ugh - that @associated_label variable needs to be set
  #@associated_label = label_id
  #@associated_row = row_id
  #macro %Q|I should see segment "#{@segment_id}" in segmented control "#{@control_id}" #{selectedness} selected|
  #should_see_row_with_label_with_text @associated_row, @associated_label, "#{@segment_id}"
end

Then /^I should see the segment is not selected and the label in the row is cleared$/ do
  _deprecated('0.1.1', 'no replacement', :pending)
  ## ugh - difficult to extract to a function because we need the
  ## @associated_row and @associated_label to be set
  #macro %Q|I should see segment "#{@segment_id}" in segmented control "#{@control_id}" is not selected|
  #should_see_row_with_label_with_text @associated_row, @associated_label, ""
end
