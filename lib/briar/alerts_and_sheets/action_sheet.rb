module Briar
  module Alerts_and_Sheets

    def query_str_for_sheet(sheet_id)
      if sheet_id
        "actionSheet marked:'#{sheet_id}'"
      else
        'actionSheet'
      end
    end

    def sheet_exists? (sheet_id)
      !query(query_str_for_sheet sheet_id).empty?
    end

    def should_see_sheet (sheet_id, button_titles=nil, sheet_title=nil)
      unless sheet_exists? (sheet_id)
        screenshot_and_raise "should see sheet marked '#{sheet_id}'"
      end

      if button_titles
        button_titles.each { |title| should_see_button_on_sheet title, sheet_id }
      end

      if sheet_title
        should_see_sheet_title sheet_title, sheet_id
      end
    end

    def should_not_see_sheet(sheet_id)
      if sheet_exists? (sheet_id)
        screenshot_and_raise "should not see sheet marked '#{sheet_id}'"
      end
    end

    def wait_for_sheet (sheet_id, timeout=BRIAR_WAIT_TIMEOUT)
      msg = "waited for '#{timeout}' seconds but did not see '#{sheet_id}'"
      wait_for(:timeout => timeout,
               :retry_frequency => BRIAR_RETRY_FREQ,
               :post_timeout => BRIAR_POST_TIMEOUT,
               :timeout_message => msg ) do
        sheet_exists? sheet_id
      end
    end

    def wait_for_sheet_to_disappear(sheet_id, timeout=BRIAR_WAIT_TIMEOUT)
      msg = "waited for '#{timeout}' seconds for '#{sheet_id}' to disappear but it is still visible"
      options = {:timeout => timeout,
                 :retry_frequency => BRIAR_RETRY_FREQ,
                 :post_timeout => BRIAR_POST_TIMEOUT,
                 :timeout_message => msg}
      wait_for(options) do
        not sheet_exists? sheet_id
      end
    end

    def error_msg_for_sheet_button(button_title, visible, sheet_id=nil)
      vis_str = visible ? 'see' : 'not see'
      sheet_str = sheet_id ? sheet_id : ''
      "should #{vis_str} button with title '#{button_title}' on sheet '#{sheet_str}'"
    end

    def sheet_button_exists? (button_title, sheet_id=nil)
      sheet_query = query_str_for_sheet sheet_id
      query("#{sheet_query} child button child label", :text).include?(button_title)
    end

    def should_see_button_on_sheet(button_title, sheet_id=nil)
      unless sheet_button_exists? button_title, sheet_id
        screenshot_and_raise error_msg_for_sheet_button button_title, true, sheet_id
      end
    end

    def should_not_see_button_on_sheet(button_title, sheet_id=nil)
      if sheet_button_exists? button_title, sheet_id
        screenshot_and_raise error_msg_for_sheet_button button_title, false, sheet_id
      end
    end

    def should_see_sheet_title(label_title, sheet_id=nil)
      sheet_query = query_str_for_sheet sheet_id
      res = query("#{sheet_query} child label", :text).include?(label_title)
      unless res
        "should see sheet #{sheet_id ? "'#{sheet_id}'" : ''} with title '#{label_title}'"
      end
    end

    def touch_sheet_button (button_title, sheet_id=nil)
      sheet_query = query_str_for_sheet sheet_id
      should_see_button_on_sheet button_title, sheet_id
      touch("#{sheet_query} child button child label marked:'#{button_title}'")
    end

    def touch_sheet_button_and_wait_for_view(button_title, view_id, sheet_id=nil)
      touch_sheet_button button_title, sheet_id
      wait_for_view view_id
    end
  end
end
