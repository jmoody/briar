
Then /^I change the time on the picker to "([^"]*)"$/ do |target_time|
  change_time_on_picker_with_time_str target_time
end

Then /^I change the date on the picker to "([^"]*)"$/ do |target_date|
  change_date_on_picker_with_date_str target_date
end

Then /^I change the picker date to "([^"]*)" and the time to "([^"]*)"$/ do |target_date, target_time|
  change_time_on_picker_with_time_str target_date
  change_date_on_picker_with_date_str target_time
end

Then /^I change the picker to (\d+) days? ago$/ do |days_ago|
  today = Date.today
  #noinspection RubyUnusedLocalVariable
  days_ago = today -= days_ago.to_i
  fmt = picker_is_in_24h_locale ? BRIAR_PICKER_24H_BRIEF_DATE_FMT : BRIAR_PICKER_12H_BRIEF_DATE_FMT
  target_date = days_ago.strftime(fmt).squeeze(' ').strip
  change_date_on_picker_with_date_str target_date
end


Then /^I change the picker to (\d+) days? ago at "([^"]*)"$/ do |days_ago, target_time|
  today = Date.today
  #noinspection RubyUnusedLocalVariable
  days_ago = today -= days_ago.to_i
  fmt = picker_is_in_24h_locale ? BRIAR_PICKER_24H_BRIEF_DATE_FMT : BRIAR_PICKER_12H_BRIEF_DATE_FMT
  target_date = days_ago.strftime(fmt).squeeze(' ').strip
  change_date_on_picker_with_date_str target_date
  change_time_on_picker_with_time_str target_time
end


#noinspection RubyUnusedLocalVariable
Then /^I change the picker date time to "([^"]*)"$/ do |target_time|
  pending 'deprecated 0.0.6 - not replaced with anything'
end


Then /^I should see that the date picker is in (time|date|date and time) mode$/ do |mode|
  if mode.eql? 'time'
    unless picker_is_in_time_mode
      screenshot_and_raise 'expected to see picker with time mode'
    end
  end

  if mode.eql? 'date'
    unless picker_is_in_date_mode
      screenshot_and_raise 'expected to see picker with date mode'
    end
  end

  if mode.eql? 'date and time'
    unless picker_is_in_date_and_time_mode
      screenshot_and_raise 'expected to see picker with date and time mode'
    end
  end
end

# requires picker is visible
Then /^I should see that the time on the picker is now$/ do
  should_see_time_on_picker_is_now
end

# requires a time or date change.  picker does not need to be visible
Then /^I should see that the "([^"]*)" row has the time I just entered in the "([^"]*)" label$/ do |row_id, label_id|
  should_see_row_has_time_i_just_entered row_id, label_id
end

When(/^I change the time on the picker to "([^"]*)", I should see the "([^"]*)" label has the correct time$/) do |time_str, label_id|
  change_time_on_picker_with_time_str time_str
  should_see_label_has_time_i_just_entered label_id
end

# does not require a time or date change. picker needs to be visible
Then /^I should see that the "([^"]*)" row has the same time as the picker in the "([^"]*)" label$/ do |row_id, label_id|
  should_see_row_has_label_with_time_on_picker row_id, label_id
end

Then /^I change the minute interval on the picker to (1|5|10|30) minutes?$/ do |target_interval|
  change_minute_interval_on_picker target_interval.to_i
end

Then /^I change the time on the picker to (\d+) minutes? from now$/ do |target_minutes|
  change_time_on_picker_to_minutes_from_now (target_minutes)
end

Then /^I change the time on the picker to (\d+) minutes? before now$/ do |target_minutes|
  change_time_on_picker_to_minutes_before_now (target_minutes)
end

