#include Briar::Picker::Date

# steps

Then /^I change the time on the picker to "([^"]*)"$/ do |target_time|
  screenshot_and_raise 'picker is not in date time or time mode' unless picker_is_in_time_mode or picker_is_in_date_and_time_mode
  if picker_has_calabash_additions
    date_str_to_send = date_str_to_send_to_picker_from_time_str target_time
    set_picker_date_with_date_time_str (date_str_to_send)
  else
    tokens = target_time.split(/[: ]/)
    screenshot_and_raise "could not parse '#{target_time}' into a valid time" if tokens.count > 3 or tokens.count < 1
    time_in_24h_locale = tokens.count == 2
    hour_token = tokens[0].to_i
    period_token = tokens[2]
    if time_in_24h_locale
      screenshot_and_raise "'#{hour_token}' is not on (0, 23)" unless (0..23).member?(hour_token)
      period_token = hour_token > 11 ? PICKER_PM : PICKER_AM
    else
      screenshot_and_raise "'#{hour_token}' is not on (1, 12)" unless (0..12).member?(hour_token)
      am_pm_token = tokens[2]
      screenshot_and_raise "'#{am_pm_token}' is not a recognized period (AM or PM)" unless (am_pm_token.eql? PICKER_AM or am_pm_token.eql? PICKER_PM)
      hour_token = 0 if hour_token == 12 and am_pm_token.eql? PICKER_AM
      hour_token = hour_token + 12 if hour_token < 12 and am_pm_token.eql? PICKER_PM
    end

    minute_token = tokens[1].to_i
    screenshot_and_raise "'#{minute_token}'is not on (0, 59)" unless (0..59).member?(minute_token)

    # rollback the date by 1 to avoid maxi date problems
    # decided this was not a good idea because sometimes the rollback step below
    # would not fire
    # picker_scroll_down_on_column 0 if picker_is_in_date_and_time_mode

    picker_scroll_to_hour hour_token
    picker_scroll_to_minute minute_token

    picker_scroll_to_period period_token if picker_is_in_12h_locale

    # rollback the change we made above
    # decided this was not a good idea
    # sometimes this does not fire so you can end up with inconsistent dates
    # see the test below
    # picker_scroll_up_on_column 0 if picker_is_in_date_and_time_mode
  end

  @date_picker_time_12h = picker_is_in_12h_locale ? picker_time_12h_str : picker_time_for_other_locale
  @date_picker_time_24h = picker_is_in_24h_locale ? picker_time_24h_str : picker_time_for_other_locale

  # this test catches problems (it is how i caught the scroll down/scroll up
  # described in the comment block above)
  unless time_strings_are_equivalent(@date_picker_time_12h, @date_picker_time_24h)
    screenshot_and_raise "ERROR: changing the picker resulted in two different times: 12H => '#{@date_picker_time_12h}' 24H => '#{@date_picker_time_24h}'"
  end

  if picker_is_in_date_and_time_mode
    @date_picker_date_time_12h = picker_is_in_12h_locale ? picker_date_and_time_str_12h : picker_date_and_time_str_for_other_locale
    @date_picker_date_time_24h = picker_is_in_24h_locale ? picker_date_and_time_str_24h : picker_date_and_time_str_for_other_locale
    # this test catches problems (it is how i caught the scroll down/scroll up
    # described in the comment block above)
    unless date_time_strings_are_equivalent(@date_picker_date_time_12h, @date_picker_date_time_24h)
      screenshot_and_raise "ERROR: changing the picker resulted in two different dates: 12H => '#{@date_picker_date_time_12h}' 24H => '#{@date_picker_date_time_24h}'"
    end
  end

  unless target_time.eql? @date_picker_time_12h or target_time.eql? @date_picker_time_24h
    screenshot_and_raise "tried to change the time to '#{target_time}' but found '#{@date_picker_time_12h}' or '#{@date_picker_time_24h}'"
  end
end

Then /^I change the date on the picker to "([^"]*)"$/ do |target_date|
  if picker_has_calabash_additions
    date_str_to_send = date_str_to_send_to_picker_from_date_str target_date
    set_picker_date_with_date_time_str (date_str_to_send)
  else
    unless picker_weekday_month_day_is(target_date)
      # figure out which way to turn the picker
      # target = Date.parse(target_date)
      dir = (Date.parse(target_date) < Date.today) ? 'down' : 'up'
      limit = 60
      count = 0
      begin
        dir.eql?('down') ? picker_scroll_down_on_column(0) : picker_scroll_up_on_column(0)
        sleep(PICKER_STEP_PAUSE)
        count = count + 1
      end while ((not picker_weekday_month_day_is(target_date)) and count < limit)
    end
    unless picker_weekday_month_day_is(target_date)
      screenshot_and_raise "scrolled '#{limit}' and could not change date to #{target_date}"
    end

    @date_picker_date_time_12h = picker_is_in_12h_locale ? picker_date_and_time_str_12h : picker_date_and_time_str_for_other_locale
    @date_picker_date_time_24h = picker_is_in_24h_locale ? picker_date_and_time_str_24h : picker_date_and_time_str_for_other_locale
    if picker_is_in_date_and_time_mode
      @date_picker_time_12h = picker_is_in_12h_locale ? picker_time_12h_str : picker_time_for_other_locale
      @date_picker_time_24h = picker_is_in_24h_locale ? picker_time_24h_str : picker_time_for_other_locale
      unless time_strings_are_equivalent(@date_picker_time_12h, @date_picker_time_24h)
        screenshot_and_raise "ERROR: changing the picker resulted in two different times: 12H => '#{@date_picker_time_12h}' 24H => '#{@date_picker_time_24h}'"
      end
    end
  end
end


Then /^I change the picker date to "([^"]*)" and the time to "([^"]*)"$/ do |target_date, target_time|
  macro %Q|I change the date on the picker to "#{target_date}"|
  macro %Q|I change the time on the picker to "#{target_time}"|
end

Then /^I change the picker to (\d+) days? ago$/ do |days_ago|
  today = Date.today
  days_ago = today -= days_ago.to_i
  fmt = picker_is_in_24h_locale ? PICKER_24H_DATE_FMT : PICKER_12H_DATE_FMT
  target_date = days_ago.strftime(fmt).squeeze(' ').strip
  macro %Q|I change the date on the picker to "#{target_date}"|
end


Then /^I change the picker to (\d+) days? ago at "([^"]*)"$/ do |days_ago, target_time|
  today = Date.today
  days_ago = today -= days_ago.to_i
  fmt = picker_is_in_24h_locale ? PICKER_24H_DATE_FMT : PICKER_12H_DATE_FMT
  target_date = days_ago.strftime(fmt).squeeze(' ').strip
  macro %Q|I change the picker date to "#{target_date}" and the time to "#{target_time}"|
end

# requires that the picker is visible
Then /^the text in the "([^"]*)" label should match picker date and time$/ do |label_id|
  text = query("view marked:'#{label_id}'", :text).first
  screenshot_and_raise "could not find label with id '#{label_id}'"
  date_time_24h = picker_is_in_24h_locale ? picker_date_and_time_str_24h : picker_date_and_time_str_for_other_locale
  date_time_12h = picker_is_in_12h_locale ? picker_date_and_time_str_12h : picker_date_and_time_str_for_other_locale
  unless (text.eql? date_time_12h) or (text.eql? date_time_24h)
    screenshot_and_raise "expected '#{text}' to match '#{date_time_12h}' or '#{date_time_24h}'"
  end
end

Then /^I change the picker date time to "([^"]*)"$/ do |target_time|
  date_str = picker_date_str
  macro %Q|I change the picker date to "#{date_str}" and the time to "#{target_time}"|
end

Then /^I should see that the date picker is in time mode$/ do
  res = query('datePicker', :datePickerMode).first
  unless res
    screenshot_and_raise 'expected to a date picker'
  end
  unless res == UIDatePickerModeTime
    screenshot_and_raise "expected to see picker with time mode but found mode '#{res}'"
  end
end

# requires picker is visible
Then /^I should see that the time on the picker is now$/ do
  time_hash =  time_hash_by_add_minutes_until_at_closest_interval (now_time_12h_locale)
  at_interval_12h = time_hash[:h12]
  at_interval_24h = time_hash[:h24]
  picker_time = picker_time_str
  unless picker_time.eql? at_interval_12h or picker_time.eql? at_interval_24h
    screenshot_and_raise "expected to picker time to be '#{at_interval_12h}' or '#{at_interval_24h}' but found '#{picker_time}'"
  end
end

# requires a time or date change.  picker does not need to be visible
Then /^I should see that the "([^"]*)" row has the time I just entered in the "([^"]*)" label$/ do |row_id, label_id|
  arr = query("tableViewCell marked:'#{row_id}' isHidden:0 descendant label marked:'#{label_id}'", :text)
  screenshot_and_raise "could not find '#{label_id}' in the '#{row_id}' row" if arr.empty?
  actual_text = arr.first
  unless (actual_text.eql? @date_picker_time_12h) or (actual_text.eql? @date_picker_time_24h)
    screenshot_and_raise "expected to see '#{@date_picker_time_12h}' or '#{@date_picker_time_24h}' in '#{label_id}' but found '#{actual_text}'"
  end
end

# does not require a time or date change. picker needs to be visible
Then /^I should see that the "([^"]*)" row has the same time as the picker in the "([^"]*)" label$/ do |row_id, label_id|
  arr = query("tableViewCell marked:'#{row_id}' isHidden:0 descendant label marked:'#{label_id}'", :text)
  screenshot_and_raise "could not find '#{label_id}' in the '#{row_id}'" if arr.empty?
  time_str_12h = picker_is_in_12h_locale ? picker_time_12h_str : picker_time_for_other_locale
  time_str_24h = picker_is_in_24h_locale ? picker_time_24h_str : picker_time_for_other_locale
  actual_text = arr.first
  unless (actual_text.eql? time_str_12h) or (actual_text.eql? time_str_24h)
    screenshot_and_raise "expected to see '#{time_str_12h}' or '#{time_str_24h}' in '#{label_id}' but found '#{actual_text}'"
  end
end

# requires a time or date change.  picker does not need to be visible
Then /^I should see that the "([^"]*)" row has the date and time I just entered in the "([^"]*)" label$/ do |row_id, label_id|
  arr = query("tableViewCell marked:'#{row_id}' isHidden:0 descendant label marked:'#{label_id}'", :text)
  screenshot_and_raise "could not find '#{label_id}' in the '#{row_id}' row" if arr.empty?
  actual_text = arr.first
  unless (actual_text.eql? @date_picker_date_time_12h) or (actual_text.eql? @date_picker_date_time_24h)
    screenshot_and_raise "expected to see '#{@date_picker_date_time_12h}' or '#{@date_picker_date_time_24h}' in '#{label_id}' but found '#{actual_text}'"
  end
end

Then /^I change the minute interval on the picker to (1|5|10|30) minutes?$/ do |target_interval|
  res = query('datePicker', [{setMinuteInterval:target_interval.to_i}])
  screenshot_and_raise 'did not find a date picker - could not set the minute interval' if res.empty?
  sleep(PICKER_STEP_PAUSE * 5)
  @picker_minute_interval = target_interval.to_i
end

Then /^I change the time on the picker to (\d+) minutes? from now$/ do |target_minute|
  future = Time.new + (60 * target_minute.to_i)
  time_str = future.strftime(PICKER_12H_TIME_FMT).squeeze(' ').strip
  macro %Q|I change the time on the picker to "#{time_str}"|
  sleep(PICKER_STEP_PAUSE)
end

Then /^I change the time on the picker to (\d+) minutes? before now$/ do |target_minute|
  past = Time.new - (60 * target_minute.to_i)
  time_str = past.strftime(PICKER_12H_TIME_FMT).squeeze(' ').strip
  macro %Q|I change the time on the picker to "#{time_str}"|
  sleep(PICKER_STEP_PAUSE)
end

