require 'date'
require 'calabash-cucumber/calabash_steps'

module Briar
  module Picker
    module Date
      include Briar::Picker_Shared
=begin
 TODO use minute interval modes 5,10,15 etc. to test if date is reachable
 TODO use the max/min dates to determine if a date is reachable
 TODO when manually moving the picker wheels - speed things up by figuring out which direction to scroll the hour/minutes
=end


=begin

requires: picker_common_step.rb

examples

    Then I should see that the date picker is in time mode
    Then I should see that the time on the picker is now

    Then I change the time on the picker to "1:45 PM"
    Then I change the time on the picker to "13:45"

    Then I change the date on the picker to "Sat Nov 17"
    Then I change the date on the picker to "Sat 17 Nov"

    Then I change the picker date to "Sat Nov 17" and the time to "0:00"
    Then I change the picker date to "Sat 17 Nov" and the time to "12:00 AM"

    Then I change the picker to 2 days ago at "9:30 PM"
    Then I should see that the "checkin" row has the time I just entered in the "status" label


this file provides 2 ways to manipulate a date picker:

1. AUTOMATIC <== setting the date directly using a UIDatePicker category method
2. MANUAL <== setting the date by manipulating the picker wheels

there are pros and cons for each approach.

AUTOMATIC pros
1. the date selection happens almost instantly
2. there is very little parsing of date and time strings <== fewer errors
3. it is accomplished in a small number of lines of code <== fewer errors

AUTOMATIC cons
1. it does not really simulate the user interaction with the picker wheels.

   this is actually very hard to do because there are cases where changing
   one column will cause another column to change.  for example: when in 12h
   mode, if the user rotates the hour to 12, then the period column will change.
   this change cannot be detected on the calabash side so either it has to be
   guarded against (don't rotate past 12) or the AM/PM must be changed last.

2. requires a category on UIDatePicker <== pollutes the application environment
3. uses the query language to make changes to application state <== doesn't seem kosher

   in my mind this is a little like the keyboard_enter_text because that method
   enters text in a way that no user can (i.e. so fast)

MANUAL pros
1. it directly simulates what a user does


MANUAL cons
1. it is very slow <== long tests are a drag
2. there is a lot of string <==> date parsing <== more errors
3. lots of special case handling <== more errors


to use the automatic mode, include this category in your CALABASH target

=== BEGIN ===
@interface UIDatePicker (CALABASH_ADDITIONS)
- (NSString *) hasCalabashAdditions:(NSString *) aSuccessIndicator;
- (BOOL) setDateWithString:(NSString *)aString
                    format:(NSString *) aFormat
                  animated:(BOOL) aAnimated;
@end


@implementation UIDatePicker (CALABASH_ADDITIONS)
- (NSString *) hasCalabashAdditions:(NSString *) aSuccessIndicator {
  return aSuccessIndicator;
}

- (BOOL) setDateWithString:(NSString *)aString
                    format:(NSString *) aFormat
                  animated:(BOOL) aAnimated {
  NSDateFormatter *df = [[NSDateFormatter alloc] init];
  [df setDateFormat:aFormat];
  NSDate *date = [df dateFromString:aString];
  if (date == nil) return NO;
  [self setDate:date animated:aAnimated];
  return YES;
}
@end
=== END ===

=end

# 0.2 is too fast because the picker does not pause at the date long enough for
# the date to change.  0.3 seems to work, but 0.4 is best i think.
      PICKER_STEP_PAUSE = 0.4.to_f
      PICKER_AM = "AM"
      PICKER_PM = "PM"

# most locales and situations prefer _not_ to have leading zeros on hours in 24h
# see usage below to find out when and if the zeros are stripped
      PICKER_24H_TIME_FMT = '%H:%M'
      PICKER_12H_TIME_FMT = '%l:%M %p'
      PICKER_ISO8601_TIME_FMT = '%H:%M'

      PICKER_REMOVE_LEADING_ZERO_REGEX = /\A^0/

# 24h locales - Fri 16 Nov - 24h locales
      PICKER_24H_DATE_FMT = '%a %e %b'
# common format for US Fri Nov 16
      PICKER_12H_DATE_FMT = '%a %b %e'

# our canonical format for testing if two dates are the same
      PICKER_ISO8601_DATE_FMT = '%Y-%m-%d'
      PICKER_ISO8601_DATE_TIME_FMT = '%Y-%m-%d %H:%M'

# when we are using the date picker category, this is the format of the string
# we will send to setDateWithString:animated:
#
# ex. 2012_11_18_16_45
      PICKER__RUBY___SET_PICKER_DATE__DATE_AND_TIME_FMT = '%Y_%m_%d_%H_%M'
      PICKER__OBJC___SET_PICKER_DATE__DATE_AND_TIME_FMT = 'yyyy_MM_dd_HH_mm'

# iOS 5
      PICKER_VIEW_CLASS_IOS5 = "datePickerView"
      PICKER_VIEW_CLASS_IOS6 = "view:'_UIDatePickerView'"

# testing for existence
      def should_see_date_picker (picker_id)
        res = !query("datePicker marked:'#{picker_id}'").empty?
        unless res
          screenshot_and_raise "could not find date picker #{picker_id}"
        end
      end

# getting dates from the picker

      def picker_date_time
        res = query("datePicker", :date)
        screenshot_and_raise "expected to see a date picker" if res.empty?
        DateTime.parse(res.first)
      end

# appledoc ==> The property is an NSDate object or nil (the default), which
# means no maximum date.
      def picker_maximum_date_time
        res = query("datePicker", :maximumDate)
        screenshot_and_raise "expected to see a date picker" if res.empty?
        res.first != nil ? DateTime.parse(res.first) : nil
      end

# appledoc ==> The property is an NSDate object or nil (the default), which
# means no minimum date.
      def picker_minimum_date_time
        res = query("datePicker", :minimumDate)
        screenshot_and_raise "expected to see a date picker" if res.empty?
        res.first != nil ? DateTime.parse(res.first) : nil
      end

# automatic date setting

# checking to see if the picker is visible and has the calabash category
# additions
      def picker_has_calabash_additions
        success_value = "1"
        res = query("datePicker", [{hasCalabashAdditions:success_value}])
        screenshot_and_raise "picker is not visible" if res.empty?
        res.first.eql? success_value
      end


      def date_time_or_time_str_is_in_24h (date_time_or_time_str)
        date_time_or_time_str[-1, 1].scan(/^[a-zA-Z]/).empty?
      end

      def date_str_is_in_24h (date_str)
        !date_str[-1, 1].scan(/^[a-zA-Z]/).empty?
      end

      def date_str_to_send_to_picker_from_time_str (time_str)
        time_in_24h = date_time_or_time_str_is_in_24h time_str
        time_fmt = time_in_24h ? PICKER_24H_TIME_FMT : PICKER_12H_TIME_FMT
        date_fmt = time_in_24h ? PICKER_24H_DATE_FMT : PICKER_12H_DATE_FMT
        date_str = picker_date_time.strftime(date_fmt).squeeze(" ").strip

        date_time_str = "#{date_str} #{time_str}"
        date_time_fmt = "#{date_fmt} #{time_fmt}"

        date_time = DateTime.strptime(date_time_str, date_time_fmt)
        date_time.strftime(PICKER__RUBY___SET_PICKER_DATE__DATE_AND_TIME_FMT).squeeze(" ").strip
      end


      def date_str_to_send_to_picker_from_date_str (date_str)
        date_in_24h = date_str_is_in_24h (date_str)
        time_fmt = date_in_24h ? PICKER_24H_TIME_FMT : PICKER_12H_TIME_FMT
        date_fmt = date_in_24h ? PICKER_24H_DATE_FMT : PICKER_12H_DATE_FMT
        time_str = picker_date_time.strftime(time_fmt).squeeze(" ").strip
        date_time_str = "#{date_str} #{time_str}"
        date_time_fmt = "#{date_fmt} #{time_fmt}"
        date_time = DateTime.strptime(date_time_str, date_time_fmt)
        date_time.strftime(PICKER__RUBY___SET_PICKER_DATE__DATE_AND_TIME_FMT).squeeze(" ").strip
      end


      def set_picker_date_with_date_time_str (date_time_str, animated=1)
        query("datePicker", [{respondsToSelector:"minuteInterval"}])


        res = query("datePicker", [{setDateWithString:date_time_str},
                                   {format:"#{PICKER__OBJC___SET_PICKER_DATE__DATE_AND_TIME_FMT}"},
                                   {animated:animated.to_i}])
        screenshot_and_raise "could not find a date picker to query" if res.empty?
        if res.first.to_i == 0
          screenshot_and_raise "could not set the picker date with '#{date_time_str}' and '#{PICKER__RUBY___SET_PICKER_DATE__DATE_AND_TIME_FMT}'"
        end

        # REQUIRED
        sleep(PICKER_STEP_PAUSE)

        # the query does not create a UIControlEventValueChanged event, so we have to
        # to a touch event

        # if the picker is in time mode, then we dont need to worry about min/max
        # if the picker is date or date time mode, i think the first column is
        # always scrollable up _and_ it sends an event even if the date is beyond
        # the maximum date

        #picker_max_date = picker_maximum_date_time
        #picker_min_date = picker_minimum_date_time
        #target_date = DateTime.strptime(date_time_str, PICKER__RUBY___SET_PICKER_DATE__DATE_AND_TIME_FMT)

        picker_scroll_down_on_column 0
        sleep(PICKER_STEP_PAUSE)
        picker_scroll_up_on_column 0
        sleep(PICKER_STEP_PAUSE)
        #if (target_date + 1) > picker_max_date
        #  picker_scroll_down_on_column 0
        #  sleep(PICKER_STEP_PAUSE)
        #  picker_scroll_up_on_column 0
        #elsif (target_date - 1) < picker_min_date
        #  picker_scroll_up_on_column 0
        #  sleep(PICKER_STEP_PAUSE)
        #  picker_scroll_down_on_column 0
        #else
        #  screenshot_and_raise "could not figure out which way to rotate the day column to trigger an event"
        #end
      end

# apple docs
# You can use this property to set the interval displayed by the minutes wheel
# (for example, 15 minutes). The interval value must be evenly divided into 60;
# if it is not, the default value is used. The default and minimum values are 1;
# the maximum value is 30.
      def picker_minute_interval
        screenshot_and_raise "there is no minute in date mode" if picker_is_in_date_mode
        screenshot_and_raise "nyi" if picker_is_in_countdown_mode
        res = query("datePicker", :minuteInterval)
        screenshot_and_raise "expected to see a date picker" if res.empty?
        @picker_minute_interval = res.first
      end

      def time_hash_by_add_minutes_until_at_closest_interval (time_str, interval=picker_minute_interval())
        screenshot_and_raise "interval '#{interval}' is not on (0, 59) which is not allowed" unless (0..59).member?(interval)
        time = Time.parse(time_str)
        # normalize to zero
        time = time - time.sec
        minute = time.min
        count = 0
        unless (minute % interval) == 0
          begin
            minute = (minute > 59) ? 0 : minute + 1
            count = count + 1
          end
        end while ((minute % interval) != 0)
        time = time + (count * 60)

        {:h12 => time.strftime(PICKER_12H_TIME_FMT).squeeze(" ").strip,
         :h24 => time.strftime(PICKER_24H_TIME_FMT).squeeze(" ").strip.sub(PICKER_REMOVE_LEADING_ZERO_REGEX,""),
         :time => time}
      end

# picker modes

      UIDatePickerModeTime = 0
      UIDatePickerModeDate = 1
      UIDatePickerModeDateAndTime = 2
      UIDatePickerModeCountDownTimer = 3

      def picker_mode
        res = query("datePicker", :datePickerMode)
        screenshot_and_raise "expected to see a date picker" if res.empty?
        res.first
      end

      def picker_is_in_time_mode
        picker_mode == UIDatePickerModeTime
      end

      def picker_is_in_date_mode
        picker_mode == UIDatePickerModeDate
      end

      def picker_is_in_date_and_time_mode
        picker_mode == UIDatePickerModeDateAndTime
      end

      def picker_is_in_countdown_mode
        picker_mode == UIDatePickerModeCountDownTimer
      end

# columns for different modes

      def picker_column_for_hour
        screenshot_and_raise "there is no hour column in date mode" if picker_is_in_date_mode
        screenshot_and_raise "nyi" if picker_is_in_countdown_mode
        picker_is_in_time_mode ? 0 : 1
      end

      def picker_column_for_minute
        screenshot_and_raise "there is no minute column in date mode" if picker_is_in_date_mode
        screenshot_and_raise "nyi" if picker_is_in_countdown_mode
        picker_is_in_time_mode ? 1 : 2
      end

      def picker_column_for_period
        screenshot_and_raise "there is no period column in date mode" if picker_is_in_date_mode
        screenshot_and_raise "nyi" if picker_is_in_countdown_mode
        picker_is_in_time_mode ? 2 : 3
      end

# 12h or 24h locale

      def picker_is_in_12h_locale
        screenshot_and_raise "12h/24h mode is not applicable to this mode" if picker_is_in_date_mode or picker_is_in_countdown_mode
        column = picker_column_for_period
        !query("pickerTableView index:#{column}").empty?
      end

      def picker_is_in_24h_locale
        !picker_is_in_12h_locale
      end

# dealing with the period (aka meridian) column

# this will cause problems with localizations - for example:
# pt (lisbon) - a.m./p.m.
# de - nach/vor
      def picker_period
        screenshot_and_raise "picker is not in 12h mode" if picker_is_in_24h_locale
        res_ios5 = query(PICKER_VIEW_CLASS_IOS5, :_amPmValue)[0]
        res_ios6 = query(PICKER_VIEW_CLASS_IOS6, :_amPmValue)[0]
        period =  res_ios5 != nil ? res_ios5.to_i : res_ios6.to_i
        period == 0 ? PICKER_AM : PICKER_PM
      end

      def picker_period_is_am?
        picker_period.eql?("AM")
      end

      def picker_period_is_pm?
        picker_period.eql?("PM")
      end

# weekday, month, day, etc

      def picker_weekday
        screenshot_and_raise "weekday is not applicable to this mode" if picker_is_in_time_mode or picker_is_in_countdown_mode
        res = query("datePickerWeekMonthDayView", :weekdayLabel, :text)[2]
        # need to guard against Today showing
        res == nil ? Date.today.strftime('%a') : res
      end

      def picker_month_day
        screenshot_and_raise "month/day is not applicable to this mode" if picker_is_in_time_mode or picker_is_in_countdown_mode
        res = query("datePickerWeekMonthDayView", :dateLabel, :text)[2]
        picker_iso = picker_date_time.strftime(PICKER_ISO8601_DATE_FMT).squeeze(" ").strip
        today = Date.today
        today_iso = today.strftime(PICKER_ISO8601_DATE_FMT).squeeze(" ").strip
        fmt = picker_is_in_24h_locale ? '%e %b' : '%b %e'
        (picker_iso.eql? today_iso) ? today.strftime(fmt) : res
      end

      def picker_date_str
        "#{picker_weekday} #{picker_month_day}".strip.squeeze(" ")
      end

      def picker_weekday_month_day_is (weekday_month_day)
        weekday_month_day.eql? picker_date_str
      end

# dealing with time

      def picker_hour_24h
        screenshot_and_raise "hour is not applicable to this mode" if picker_is_in_countdown_mode or picker_is_in_date_mode
        #  query always returns as 24h
        res_ios5 = query(PICKER_VIEW_CLASS_IOS5, :hour).first
        res_ios6 = query(PICKER_VIEW_CLASS_IOS6, :hour).first
        return res_ios5 != nil ? res_ios5 : res_ios6
        #query("datePickerView", :hour).first
      end

      def picker_hour_24h_str
        screenshot_and_raise "hour is not applicable to this mode" if picker_is_in_countdown_mode or picker_is_in_date_mode
        "%02d" % picker_hour_24h
      end

      def picker_hour_12h
        screenshot_and_raise "hour is not applicable to this mode" if picker_is_in_countdown_mode or picker_is_in_date_mode
        hour_24h = picker_hour_24h
        return 12 if hour_24h == 0
        hour_24h > 12 ? hour_24h - 12 : hour_24h
      end

      def picker_hour_12h_str
        screenshot_and_raise "hour is not applicable to this mode" if picker_is_in_countdown_mode or picker_is_in_date_mode
        "#{picker_hour_12h}"
      end

      def picker_hour_24h_is (target_hour)
        target_hour == picker_hour_24h
      end

      def picker_hour_12h_is (target_hour)
        target_hour == picker_hour_12h
      end

      def picker_hour_is (target_hour)
        picker_is_in_24h_locale ? picker_hour_24h_is(target_hour) : picker_hour_12h_is(target_hour)
      end

      def picker_minute
        screenshot_and_raise "hour is not applicable to this mode" if picker_is_in_countdown_mode or picker_is_in_date_mode
        res_ios5 = query(PICKER_VIEW_CLASS_IOS5, :minute).first
        res_ios6 = query(PICKER_VIEW_CLASS_IOS6, :minute).first
        return res_ios5 != nil ? res_ios5 : res_ios6
        #query("datePickerView", :minute).first
      end

      def picker_minute_str
        screenshot_and_raise "hour is not applicable to this mode" if picker_is_in_countdown_mode or picker_is_in_date_mode
        "%02d" % picker_minute
        #"%02d" % query("datePickerView", :minute).first
      end

      def picker_minute_is (target_minute)
        target_minute == picker_minute
      end

      def picker_time_24h_str
        screenshot_and_raise "the time is not applicable for this mode" if picker_is_in_date_mode or picker_is_in_countdown_mode
        "#{picker_hour_24h_str}:#{picker_minute_str}".strip.sub(PICKER_REMOVE_LEADING_ZERO_REGEX, "")
      end

      def picker_time_12h_str
        screenshot_and_raise "the time is not applicable for this mode" if picker_is_in_date_mode or picker_is_in_countdown_mode
        "#{picker_hour_12h_str}:#{picker_minute_str} #{picker_period}"
      end

      def picker_time_str
        screenshot_and_raise "the time is not applicable for this mode" if picker_is_in_date_mode or picker_is_in_countdown_mode
        picker_is_in_24h_locale ? picker_time_24h_str : picker_time_12h_str
      end

      def picker_time_for_other_locale
        time_str = picker_is_in_24h_locale ? picker_time_24h_str : picker_time_12h_str
        fmt_str = picker_is_in_24h_locale ? PICKER_12H_TIME_FMT : PICKER_24H_TIME_FMT
        Time.parse(time_str).strftime(fmt_str).squeeze(" ").strip.sub(PICKER_REMOVE_LEADING_ZERO_REGEX,"")
      end

# date and time

      def picker_date_and_time_str_24h
        screenshot_and_raise "the time is not applicable for this mode" if picker_is_in_date_mode or picker_is_in_countdown_mode
        "#{picker_date_str} #{picker_time_24h_str}"
      end

      def picker_date_and_time_str_12h
        screenshot_and_raise "the time is not applicable for this mode" if picker_is_in_date_mode or picker_is_in_countdown_mode
        "#{picker_date_str} #{picker_time_12h_str}"
      end

      def picker_date_and_time_str
        "#{picker_date_str} #{picker_time_str}"
      end

      def picker_date_and_time_str_for_other_locale
        "#{picker_date_str} #{picker_time_for_other_locale}"
      end

# useful

      def now_times_map
        now = Time.new
        {:h12 => now.strftime(PICKER_12H_TIME_FMT).squeeze(" ").strip,
         :h24 => now.strftime(PICKER_24H_TIME_FMT).squeeze(" ").strip.sub(PICKER_REMOVE_LEADING_ZERO_REGEX,""),
         :time => now}
      end

      def now_time_24h_locale
        now_times_map[:h24]
      end

      def now_time_12h_locale
        now_times_map[:h12]
      end

# scrolling picker

      def picker_scroll_to_hour (target_hour_int_24h_notation)
        screenshot_and_raise "nyi" if picker_is_in_countdown_mode
        column = picker_column_for_hour
        limit = 25
        count = 0
        unless picker_hour_24h_is target_hour_int_24h_notation
          begin
            picker_scroll_up_on_column(column)
            sleep(PICKER_STEP_PAUSE)
            count = count + 1
          end while (not picker_hour_24h_is target_hour_int_24h_notation) and count < limit
        end
        unless picker_hour_24h_is target_hour_int_24h_notation
          screenshot_and_raise "scrolled '#{limit}' but could not change hour to '#{target_hour_int_24h_notation}'"
        end
      end

      def picker_scroll_to_minute (target_minute_int)
        screenshot_and_raise "nyi" if picker_is_in_countdown_mode
        column = picker_column_for_minute
        limit = 61
        count = 0
        unless picker_minute_is target_minute_int
          begin
            picker_scroll_up_on_column(column)
            sleep(PICKER_STEP_PAUSE)
            count = count + 1
          end while (not picker_minute_is target_minute_int) and count < limit
        end
        unless picker_minute_is target_minute_int
          screenshot_and_raise "scrolled '#{limit}' but could not change minute to '#{target_minute_int}'"
        end
      end

      def picker_scroll_to_period(target_period_str)
        screenshot_and_raise "nyi" if picker_is_in_countdown_mode
        screenshot_and_raise "period is not applicable to 24h locale" if picker_is_in_24h_locale
        column = picker_column_for_period
        limit = 3
        count = 0
        unless picker_period.eql? target_period_str
          begin
            if picker_period_is_am?
              scroll_to_row("pickerTableView index:#{column}", 1)
            else
              scroll_to_row("pickerTableView index:#{column}", 0)
            end
            sleep(PICKER_STEP_PAUSE)
            count = count + 1
          end while (not picker_period.eql? target_period_str) and count < limit
        end
        unless picker_period.eql? target_period_str
          screenshot_and_raise "scrolled '#{limit}' but could not change period to '#{target_period_str}'"
        end
      end


# utility

      def time_strings_are_equivalent (a, b)
        a_iso_str = Time.parse(a).strftime(PICKER_ISO8601_TIME_FMT)
        b_iso_str = Time.parse(b).strftime(PICKER_ISO8601_TIME_FMT)
        a_iso_str.eql? b_iso_str
      end

      def date_time_strings_are_equivalent (a, b)
        a_iso_str = Date.parse(a).strftime(PICKER_ISO8601_DATE_TIME_FMT)
        b_iso_str = Date.parse(b).strftime(PICKER_ISO8601_DATE_TIME_FMT)
        a_iso_str.eql? b_iso_str
      end

    end
  end
end
