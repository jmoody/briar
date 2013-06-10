UIDatePickerModeTime = 0
UIDatePickerModeDate = 1
UIDatePickerModeDateAndTime = 2
UIDatePickerModeCountDownTimer = 3

# most locales and situations prefer _not_ to have leading zeros on hours in 24h
# see usage below to find out when and if the zeros are stripped
BRIAR_PICKER_24H_TIME_FMT = '%H:%M'
BRIAR_PICKER_12H_TIME_FMT = '%l:%M %p'

BRIAR_TIME_FORMATS = {:h24 => BRIAR_PICKER_24H_TIME_FMT,
                      :h12 => BRIAR_PICKER_12H_TIME_FMT}

BRIAR_REMOVE_LEADING_ZERO_REGEX = /\A^0/

# 24h locales - Fri 16 Nov - 24h locales
BRIAR_PICKER_24H_BRIEF_DATE_FMT = '%a %e %b'
# common format for US Fri Nov 16
BRIAR_PICKER_12H_BRIEF_DATE_FMT = '%a %b %e'

BRIAR_DATE_FORMATS = {:brief_24h => BRIAR_PICKER_24H_BRIEF_DATE_FMT,
                      :brief_12h => BRIAR_PICKER_12H_BRIEF_DATE_FMT}


module Briar
  module Picker
    module DateCore

      def query_string_for_picker (picker_id = nil)
        picker_id.nil? ? 'datePicker' : "datePicker marked:'#{picker_id}'"
      end

      def should_see_date_picker (picker_id=nil)
        query_str = query_string_for_picker picker_id
        if query(query_str).empty?
          screenshot_and_raise "should see picker with query '#{query_str}'"
        end
        query_str
      end

      def ruby_time_from_picker (options = {:picker_id => nil,
                                            :convert_time_to_utc => false})
        picker_id = picker_id_from_options options

        if picker_is_in_countdown_mode picker_id
          screenshot_and_raise 'method is not available for pickers that are not in date or date time mode'
        end
        query_str = should_see_date_picker picker_id
        res = query(query_str, :date)
        if res.empty?
          screenshot_and_raise "should be able to get date from picker with query '#{query_str}'"
        end

        rdt = DateTime.parse(res.first)
        convert = convert_to_utc_from_options options
        if convert
          rdt.to_time.utc
        else
          rdt.to_time
        end
      end


      # appledoc ==> The property is an NSDate object or nil (the default),
      # which means no maximum date.
      def picker_maximum_date_time (picker_id = nil)
        if picker_is_in_countdown_mode picker_id
          screenshot_and_raise 'method is not available for pickers that are not in date or date time mode'
        end

        query_str = should_see_date_picker picker_id
        res = query(query_str, :maximumDate)
        if res.empty?
          screenshot_and_raise "should be able to get max date from picker with query '#{query_str}'"
        end
        return nil if res.first.nil?
        DateTime.parse(res.first)
      end

      # appledoc ==> The property is an NSDate object or nil (the default),
      # which means no minimum date.
      def picker_minimum_date_time (picker_id = nil)
        if picker_is_in_countdown_mode picker_id
          screenshot_and_raise 'method is not available for pickers that are not in date or date time mode'
        end

        query_str = should_see_date_picker picker_id
        res = query(query_str, :minimumDate)
        if res.empty?
          screenshot_and_raise "should be able to get min date from picker with query '#{query_str}'"
        end
        return nil if res.first.nil?
        DateTime.parse(res.first)
      end

      def picker_mode(picker_id=nil)
        query_str = should_see_date_picker picker_id
        res = query(query_str, :datePickerMode)
        if res.empty?
          screenshot_and_raise "should be able to get mode from picker with query '#{query_str}'"
        end
        res.first
      end

      def picker_is_in_time_mode(picker_id=nil)
        picker_mode(picker_id) == UIDatePickerModeTime
      end

      def picker_is_in_date_mode(picker_id=nil)
        picker_mode(picker_id) == UIDatePickerModeDate
      end

      def picker_is_in_date_and_time_mode(picker_id=nil)
        picker_mode(picker_id) == UIDatePickerModeDateAndTime
      end

      def picker_is_in_countdown_mode(picker_id=nil)
        picker_mode(picker_id) == UIDatePickerModeCountDownTimer
      end

      def picker_id_from_options (options={:picker_id => nil})
        options == nil ? nil : options[:picker_id]
      end

      def convert_to_utc_from_options(options={:convert_time_to_utc => false})
        return false if options.nil?
        return false if not options.has_key?(:convert_time_to_utc)
        options[:convert_time_to_utc]
      end

      # apple docs
      # You can use this property to set the interval displayed by the minutes wheel
      # (for example, 15 minutes). The interval value must be evenly divided into 60;
      # if it is not, the default value is used. The default and minimum values are 1;
      # the maximum value is 30.
      def picker_minute_interval(picker_id = nil)
        screenshot_and_raise 'there is no minute in date mode' if picker_is_in_date_mode
        query_str = should_see_date_picker picker_id
        res = query(query_str, :minuteInterval)
        if res.empty?
          screenshot_and_raise "should be able to get minute interval from picker with '#{query_str}'"
        end
        @picker_minute_interval = res.first
      end

      # funky little bugger - used to change a picker to the nearest minute
      # based on the minute interval
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

        {:h12 => time.strftime(BRIAR_PICKER_12H_TIME_FMT).squeeze(' ').strip,
         :h24 => time.strftime(BRIAR_PICKER_24H_TIME_FMT).squeeze(' ').strip.sub(BRIAR_REMOVE_LEADING_ZERO_REGEX, ''),
         :time => time}
      end


      # is the picker in 12h or 24h mode
      def picker_column_for_period(picker_id = nil)
        if picker_is_in_date_mode picker_id or picker_is_in_countdown_mode picker_id
          screenshot_and_raise '12h/24h mode is not applicable to this mode'
        end
        picker_is_in_time_mode ? 2 : 3
      end

      # 12h or 24h locale
      def picker_is_in_12h_locale(picker_id = nil)
        if picker_is_in_date_mode picker_id or picker_is_in_countdown_mode picker_id
          screenshot_and_raise '12h/24h mode is not applicable to this mode'
        end

        column = picker_column_for_period(picker_id=nil)
        !query("pickerTableView index:#{column}").empty?
      end

      def picker_is_in_24h_locale(picker_id=nil)
        if picker_is_in_date_mode picker_id or picker_is_in_countdown_mode picker_id
          screenshot_and_raise '12h/24h mode is not applicable to this mode'
        end
        !picker_is_in_12h_locale picker_id
      end

      # get the times off the picker in 12h and 24h format
      def picker_time_str(format_key, options={:picker_id => nil,
                                               :convert_time_to_utc => false})
        picker_id = picker_id_from_options options

        if picker_is_in_date_mode picker_id or picker_is_in_countdown_mode picker_id
          screenshot_and_raise 'the time is not applicable for this mode'
        end
        format = BRIAR_TIME_FORMATS[format_key]
        unless format
          screenshot_and_raise "format '#{format_key}' was not one of '#{BRIAR_TIME_FORMATS}'"
        end

        time = ruby_time_from_picker options
        time.strftime(format).strip.sub(BRIAR_REMOVE_LEADING_ZERO_REGEX, '')
      end


      def picker_time_strs_hash(options={:picker_id => nil,
                                         :convert_time_to_utc => false})
        picker_id = picker_id_from_options options
        if picker_is_in_date_mode picker_id or picker_is_in_countdown_mode picker_id
          screenshot_and_raise 'the time is not applicable for this mode'
        end

        {:h24 => picker_time_str(:h24, options),
         :h12 => picker_time_str(:h12, options)}
      end

      def picker_time_strs_arr(options={:picker_id => nil,
                                        :convert_time_to_utc => false})
        picker_id = picker_id_from_options options
        if picker_is_in_date_mode picker_id or picker_is_in_countdown_mode picker_id
          screenshot_and_raise 'the time is not applicable for this mode'
        end
        [picker_time_str(:h24, options), picker_time_str(:h12, options)]
      end

      def picker_brief_date_str(format_key, options={:picker_id => nil,
                                                     :convert_time_to_utc => false})
        picker_id = picker_id_from_options options
        if picker_is_in_countdown_mode picker_id
          screenshot_and_raise 'date is not applicable for this mode'
        end
        format = BRIAR_DATE_FORMATS[format_key]
        unless format
          screenshot_and_raise "format '#{format_key}' is not one of '#{BRIAR_DATE_FORMATS.keys}'"
        end
        time = ruby_time_from_picker options
        time.strftime(format).strip.squeeze(' ')
      end

      def picker_brief_date_strs_hash(options={:picker_id => nil,
                                               :convert_time_to_utc => false})
        picker_id = picker_id_from_options options
        if picker_is_in_countdown_mode picker_id
          screenshot_and_raise 'date is not applicable for this mode'
        end
        {:brief_24h => picker_brief_date_str(:brief_24h, options),
         :brief_12h => picker_brief_date_str(:brief_12h, options)}
      end

      def picker_brief_date_strs_arr(options={:picker_id => nil,
                                              :convert_time_to_utc => false})
        picker_id = picker_id_from_options options
        if picker_is_in_countdown_mode picker_id
          screenshot_and_raise 'date is not applicable for this mode'
        end
        [picker_brief_date_str(:brief_24h, options), picker_brief_date_str(:brief_12h, options)]
      end


      def now_times_map
        utc = Time.now.utc
        now = Time.now

        {:h12 => now.strftime(BRIAR_PICKER_12H_TIME_FMT).squeeze(' ').strip,
         :h24 => now.strftime(BRIAR_PICKER_24H_TIME_FMT).squeeze(' ').strip.sub(BRIAR_REMOVE_LEADING_ZERO_REGEX, ''),
         :h12_utc => utc.strftime(BRIAR_PICKER_12H_TIME_FMT).squeeze(' ').strip,
         :h24_utc => utc.strftime(BRIAR_PICKER_24H_TIME_FMT).squeeze(' ').strip.sub(BRIAR_REMOVE_LEADING_ZERO_REGEX, ''),
         :utc => utc,
         :time => now}
      end

      def now_time_24h_locale
        now_times_map[:h24]
      end

      def now_time_12h_locale
        now_times_map[:h12]
      end

      def now_times_arr
        [now_time_24h_locale, now_time_12h_locale]
      end


    end
  end
end
