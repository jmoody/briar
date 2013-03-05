#include Briar::Picker

# may only work on circular pickers - does _not_ work on non-circular pickers
# because the visible titles do _not_ follow the selected index
Then /^I should see picker "([^"]*)" with row "([^"]*)" selected$/ do |picker_name, row_named|
  should_see_picker picker_name
  selected_title = selected_title_for_column 0
  unless selected_title.eql?(row_named)
    screenshot_and_raise "found picker named #{picker_name} but #{row_named} was not selected - found #{selected_title}"
  end
end

Then /^I scroll (up|down) on picker "([^"]*)"$/ do |dir, picker_name|
  should_see_picker picker_name
  if dir.eql? "down"
    picker_scroll_down_on_column 0
  else
    picker_scroll_up_on_column 0
  end
  step_pause
end

Then /^I scroll (up|down) on picker "([^"]*)" to row (\d+)$/ do |dir, picker, row|
  should_see_picker picker
  target_row = row.to_i
  unless picker_current_index_for_column_is(0, target_row)
    count = 0
    begin
      if dir.eql? "down"
        picker_scroll_down_on_column 0
      else
        picker_scroll_up_on_column 0
      end
      count = count + 1
      step_pause
    end while ((not picker_current_index_for_column_is(0, target_row)) and count < 20)
  end

  unless picker_current_index_for_column_is(0, target_row)
    screenshot_and_raise "scrolled #{dir} on picker 20 times but never found row #{row}"
  end
end

Then /^I should see picker "([^"]*)" has selected row (\d+)$/ do |picker, row|
  should_see_picker picker
  unless picker_current_index_for_column_is(0, row.to_i)
    screenshot_and_raise "expected picker #{picker} to have #{row} selected but found #{picker_current_index_for_column 0}"
  end
end

Then /^I should (see|not see) picker "([^"]*)"$/ do |visibility, picker|
  target = visibility.eql? "see"
  if target
    should_see_picker picker
  else
    should_not_see_picker picker
  end
end
