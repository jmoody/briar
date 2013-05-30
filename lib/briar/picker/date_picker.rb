=begin

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

=end

module Briar
  module Picker
    module DateSteps
      include Briar::Picker::DateCore
      include Briar::Picker::DateManipulation

      # requires a time or date change.  picker does not need to be visible

      def should_see_row_has_time_i_just_entered (row_id, label_id, table_id=nil)
        query_str = query_str_for_row row_id, table_id
        arr = query("#{query_str} descendant label marked:'#{label_id}'", :text)
        screenshot_and_raise "could not find '#{label_id}' in the '#{row_id}' row" if arr.empty?
        actual_text = arr.first

        unless (actual_text.eql? @date_picker_time_12h) or (actual_text.eql? @date_picker_time_24h)
          screenshot_and_raise "expected to see '#{@date_picker_time_12h}' or '#{@date_picker_time_24h}' in '#{label_id}' but found '#{actual_text}'"
        end
      end

      def change_minute_interval_on_picker (target_interval, picker_id=nil)
        query_str = should_see_date_picker picker_id
        res = query(query_str, [{setMinuteInterval: target_interval.to_i}])
        if res.empty?
          screenshot_and_raise "could not change the minute interval with query '#{query_str}'"
        end
        step_pause
        @picker_minute_interval = target_interval.to_i
      end

      # does not require a time or date change. picker needs to be visible
      def should_see_row_has_label_with_time_on_picker(row_id, label_id, options={:picker_id => nil,
                                                                                  :table_id => nil})
        picker_id = options != nil ? options[:picker_id] : nil
        should_see_date_picker picker_id
        table_id = options != nil ? options[:table_id] : nil
        query_str = query_str_for_row_content row_id, table_id
        arr = query("#{query_str} label marked:'#{label_id}'", :text)

        if arr.empty?
          screenshot_and_raise "could not find '#{label_id}' in the '#{row_id}'"
        end

        hash = picker_time_strs_hash picker_id
        time_str_12h = hash[:h12]
        time_str_24h = hash[:h24]
        actual_text = arr.first
        unless (actual_text.eql? time_str_12h) or (actual_text.eql? time_str_24h)
          screenshot_and_raise "expected to see '#{time_str_12h}' or '#{time_str_24h}' in '#{label_id}' but found '#{actual_text}'"
        end
      end

      # requires picker is visible
      #noinspection SpellCheckingInspection
      def should_see_time_on_picker_is_now (options = {:picker_id => nil,
                                                       :convert_time_to_utc => false})
        picker_time = ruby_time_from_picker options
        now_time = Time.now

        convert = convert_to_utc_from_options options
        if convert
          now_time = Time.now.utc + now_time.gmt_offset
        end

        # normalize
        picker_time = picker_time - picker_time.sec


        now_time = now_time - now_time.sec

        picker_id = picker_id_from_options options
        minute_interval = picker_minute_interval picker_id

        if minute_interval == 1 and not (picker_time == now_time)
          screenshot_and_raise "should see picker with time '#{now_time}' but found '#{picker_time}'"
        end

        max_time = now_time + (minute_interval * 60)
        min_time = now_time - (minute_interval * 60)

        unless picker_time >= min_time && picker_time <= max_time
          p "   min: '#{min_time}'"
          p "target: '#{picker_time}'"
          p "   max: '#{max_time}'"
          screenshot_and_raise "should see picker with time between '#{min_time}' and '#{max_time}' but found '#{picker_time}'"
        end
      end

      def change_time_on_picker_to_minutes_from_now (target_minutes, options={:picker_id => nil,
                                                                              :convert_time_to_utc => false})

        picker_id = picker_id_from_options options
        convert = convert_to_utc_from_options options

        if convert
          future = Time.now.gmtime + Time.now.gmtoff + (target_minutes.to_i * 60)
        else
          future = Time.new + (60 * target_minutes.to_i)
        end

        opts = {:picker_id => picker_id,
                :convert_time_to_utc => convert}

        change_time_on_picker_with_time future, opts
      end

      def change_time_on_picker_to_minutes_before_now (target_minutes, options={:picker_id => nil,
                                                                                :convert_time_to_utc => false})

        picker_id = options != nil ? options[:picker_id] : nil
        convert = options != nil ? options[:convert_time_to_utc] : false

        if convert
          past = Time.now.gmtime + Time.now.gmtoff - (target_minutes.to_i * 60)
        else
          past = Time.new - (60 * target_minutes.to_i)
        end

        opts = {:picker_id => picker_id,
                :convert_time_to_utc => convert}

        change_time_on_picker_with_time past, opts
      end
    end
  end
end
