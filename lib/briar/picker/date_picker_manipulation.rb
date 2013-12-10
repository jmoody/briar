require 'calabash-cucumber'
require 'date'

=begin

change_picker_date_time (target_dt, options)

change_time_on_picker_with_time_str (time_str, options)
change_time_on_picker_with_time (time, options)

change_date_on_picker_with_date_str (date_str, options)
change_date_on_picker_with_date (date, options)


options ==>
{
# calabash returns dates in terms of the local timezone
# sometimes you have pickers (like alarms or reminders) that use utc timezone
# WARN: only set this if you need times converted to UTC - if you are in UTC
# timezone, don't set this
:convert_time_to_utc => false,
# animat the change
:animate => true,
# optionally pass the picker id
:picker_id => nil,
# iterate over the picker's target/action pairs and call them using
# performSelector:SEL object:<picker>
:notify_targets => true
}

=end

BRIAR_PICKER_ISO8601_TIME_FMT = '%H:%M'

# our canonical format for testing if two dates are the same
BRIAR_PICKER_ISO8601_BRIEF_DATE_FMT = '%Y-%m-%d'
BRIAR_PICKER_ISO8601_BRIEF_DATE_TIME_FMT = '%Y-%m-%d %H:%M'

# ex. 2012_11_18_16_45
BRIAR_PICKER_RUBY_DATE_AND_TIME_FMT_ZONED = '%Y_%m_%d_%H_%M_%z'
BRIAR_PICKER_OBJC_DATE_AND_TIME_FMT_ZONED = 'yyyy_MM_dd_HH_mm_Z'
BRIAR_PICKER_RUBY_DATE_AND_TIME_FMT = '%Y_%m_%d_%H_%M'
BRIAR_PICKER_OBJC_DATE_AND_TIME_FMT = 'yyyy_MM_dd_HH_mm'

BRIAR_DATE_CONVERSION_FORMATS = {:objc => {:zoned => BRIAR_PICKER_OBJC_DATE_AND_TIME_FMT_ZONED,
                                           :default => BRIAR_PICKER_OBJC_DATE_AND_TIME_FMT},
                                 :ruby => {:zoned => BRIAR_PICKER_RUBY_DATE_AND_TIME_FMT_ZONED,
                                           :default => BRIAR_PICKER_RUBY_DATE_AND_TIME_FMT}}

module Briar
  module Picker
    module DateManipulation

      def date_format_for_target (target, zoned)
        res = BRIAR_DATE_CONVERSION_FORMATS[target][zoned]
        if res.nil?
          screenshot_and_raise "could not find format for target '#{target}' and zone '#{zoned}'"
        end
        res
      end

      def convert_date_time_to_objc_fmt (date_time, convert=false)
        format = date_format_for_target(:ruby, convert ? :zoned : :default)
        date_time.strftime(format).squeeze(' ').strip
      end

      def args_for_change_date_on_picker(options)
        args = []
        if options.has_key?(:notify_targets)
          args << options[:notify_targets] ? 1 : 0
        else
          args << 1
        end

        if options.has_key?(:animate)
          args << options[:animate] ? 1 : 0
        else
          args << 1
        end
        args
      end

      def target_date_for_change_time_on_picker_with_time_str(time_str, convert, picker_id=nil)
        if time_str.nil? || time_str.length == 0
          screenshot_and_raise "time str '#{time_str}' must be non-nil and non-empty"
        end
        time = Time.parse(time_str)
        target_date_for_change_time_on_picker_with_time time, convert, picker_id
      end

      def target_date_for_change_time_on_picker_with_time(target_time, convert, picker_id=nil)
        current_time = ruby_time_from_picker picker_id
        tz_offset = (convert) ? 0 : Rational((target_time.utc_offset/3600.0)/24.0)
        DateTime.new(current_time.year, current_time.mon, current_time.day,
                     target_time.hour, target_time.min,
                     0, tz_offset)
      end


      def target_date_for_change_date_on_picker_with_date_str(date_str, picker_id=nil)
        if date_str.nil? || date_str.length == 0
          screenshot_and_raise "date str '#{date_str}' must be non-nil and non-empty"
        end
        date = Date.parse(date_str)
        target_date_for_change_date_on_picker_with_date date, picker_id
      end

      def target_date_for_change_date_on_picker_with_date(target_date, picker_id=nil)
        current_time = ruby_time_from_picker picker_id
        DateTime.new(target_date.year, target_date.mon, target_date.day,
                     current_time.hour, current_time.min, 0, current_time.offset)
      end


      # pickers that use utc (reminders, alerts, etc.  do no usually have
      # min/max dates
      def ensure_can_change_picker_to_date(target_dt, picker_id=nil)
        max_date = maximum_date_time_from_picker picker_id
        if max_date and target_dt > max_date
          puts "\ntarget: '#{target_dt}'"
          puts "   max: '#{max_date}'"
          screenshot_and_raise "cannot change time to '#{target_dt}' because the picker has a maximum date of '#{max_date}'"
        end

        min_date = minimum_date_time_from_picker picker_id
        if min_date and target_dt < min_date
          p "target: '#{target_dt}'"
          p "   min: '#{min_date}'"
          screenshot_and_raise "cannot change time to #{target_dt} because the picker has a minimum date of '#{min_date}'"
        end
      end


      def change_picker_date_time (target_dt, options = {:convert_time_to_utc => false,
                                                         :animate => true,
                                                         :picker_id => nil,
                                                         :notify_targets => true})

        picker_id = picker_id_from_options options
        unless picker_is_in_time_mode picker_id or picker_is_in_date_and_time_mode picker_id
          screenshot_and_raise 'picker is not in date time or time mode'
        end

        should_see_date_picker picker_id

        convert = convert_to_utc_from_options options

        ensure_can_change_picker_to_date target_dt, picker_id

        target_str = convert_date_time_to_objc_fmt target_dt, convert
        fmt_str = date_format_for_target(:objc, convert ? :zoned : :default)

        args = args_for_change_date_on_picker options
        query_str = query_string_for_picker picker_id

        views_touched = map(query_str, :changeDatePickerDate, target_str, fmt_str, *args)

        if views_touched.empty? or views_touched.member? '<VOID>'
          screenshot_and_raise "could not change date on picker to '#{target_dt}' using query '#{query_str}' with options '#{options}'"
        end

        set_briar_date_picker_variables target_dt, options

        step_pause
        views_touched
      end

      def change_time_on_picker_with_time_str (time_str, options = {:convert_time_to_utc => false,
                                                                    :animate => true,
                                                                    :picker_id => nil,
                                                                    :notify_targets => true})
        convert = convert_to_utc_from_options options
        picker_id = picker_id_from_options options
        target_dt = target_date_for_change_time_on_picker_with_time_str time_str, convert, picker_id
        change_picker_date_time target_dt, options
      end


      def change_time_on_picker_with_time (time, options = {:convert_time_to_utc => false,
                                                            :animate => true,
                                                            :picker_id => nil,
                                                            :notify_targets => true})
        convert = convert_to_utc_from_options options
        picker_id = picker_id_from_options options
        target_dt = target_date_for_change_time_on_picker_with_time time, convert, picker_id
        change_picker_date_time target_dt, options
      end

      def change_date_on_picker_with_date_str (date_str, options = {:animate => true,
                                                                    :picker_id => nil,
                                                                    :notify_targets => true})
        picker_id = picker_id_from_options options
        target_dt = target_date_for_change_date_on_picker_with_date_str date_str, picker_id
        change_picker_date_time target_dt, options
      end


      def change_date_on_picker_with_date (date, options = {:animate => true,
                                                            :picker_id => nil,
                                                            :notify_targets => true})
        picker_id = picker_id_from_options options
        target_dt = target_date_for_change_date_on_picker_with_date date, picker_id
        change_picker_date_time target_dt, options
      end


      def set_briar_date_picker_variables(target_dt, options={:picker_id => nil,
                                                              :convert_time_to_utc => false})
        picker_id = picker_id_from_options options
        if picker_is_in_date_and_time_mode picker_id or picker_is_in_time_mode picker_id
          @date_picker_time_12h = picker_time_str :h12, options
          @date_picker_time_24h = picker_time_str :h24, options
          @date_picker_time_hash = picker_time_strs_hash options
          @date_picker_time_arr = picker_time_strs_arr options
          unless time_strings_are_equivalent @date_picker_time_12h, @date_picker_time_24h
            screenshot_and_raise "ERROR: changing the picker resulted in two different times: '#{@date_picker_time_hash}'"
          end
        end

        @date_picker_brief_date_12h = picker_brief_date_str :brief_12h, options
        @date_picker_brief_date_24h = picker_brief_date_str :brief_24h, options
        @date_picker_brief_date_hash = picker_brief_date_strs_hash options
        @date_picker_brief_date_arr = picker_brief_date_strs_arr options

        unless brief_date_strings_are_equivalent @date_picker_brief_date_12h, @date_picker_brief_date_24h
          screenshot_and_raise "ERROR: changing the picker resulted in two different dates: '#{@date_picker_brief_date_hash}'"
        end

        @date_picker_date_time = target_dt
      end


      # utility
      def time_strings_are_equivalent (a, b)
        a_iso_str = Time.parse(a).strftime(BRIAR_PICKER_ISO8601_TIME_FMT)
        b_iso_str = Time.parse(b).strftime(BRIAR_PICKER_ISO8601_TIME_FMT)
        a_iso_str.eql? b_iso_str
      end


      def brief_date_strings_are_equivalent (a, b)
        a_iso_str = Date.parse(a).strftime(BRIAR_PICKER_ISO8601_BRIEF_DATE_FMT)
        b_iso_str = Date.parse(b).strftime(BRIAR_PICKER_ISO8601_BRIEF_DATE_FMT)
        a_iso_str.eql? b_iso_str
      end


      def brief_date_time_strings_are_equivalent (a, b)
        a_iso_str = Date.parse(a).strftime(BRIAR_PICKER_ISO8601_BRIEF_DATE_TIME_FMT)
        b_iso_str = Date.parse(b).strftime(BRIAR_PICKER_ISO8601_BRIEF_DATE_TIME_FMT)
        a_iso_str.eql? b_iso_str
      end
    end
  end
end
