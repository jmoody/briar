require 'calabash-cucumber'

module Briar
  module Email

    def email_testable?
      return true if ios5?
      uia_available?
    end

    def email_not_testable?
      not email_testable?
    end

    def warn_about_no_ios5_email_view
      warn 'WARN: iOS > 5 detected - cannot test for email views on iOS simulator or devices unless we use UIAutomation'
    end

    def email_body
      query("view:'MFComposeTextContentView'", :text)
    end

    def email_body_contains? (text)
      if ios5?
        !query("view:'MFComposeTextContentView' {text LIKE '*#{text}*'}").empty?
      else
        warn 'WARN: iOS > 5 detected - cannot test for email body text'
      end
    end

    def email_subject
      query("view:'MFComposeSubjectView'", :text).first
    end

    def email_subject_is? (text)
      if ios5?
        email_subject.eql? text
      else
        warn 'WARN: iOS > 5 detected - cannot test for email subject text'
      end
    end

    def email_subject_has_text_like? (text)
      if ios5?
        !query("view:'MFComposeSubjectView' {text LIKE '*#{text}*'}").empty?
      else
        warn 'WARN: iOS > 5 detected - cannot test for email subject text'
      end
    end

    def email_to
      query("view:'_MFMailRecipientTextField'", :text).first
    end

    def email_to_field_is? (text)
      if ios5?
        email_to.eql? text
      else
        warn 'WARN: iOS > 5 detected - cannot test for email to field'
      end
    end

    def email_to_contains? (address)
      addrs = tokenize_list(email_to)
      addrs.include? address
    end

    # @todo replace sleep with a wait_*
    def should_see_recipients (addresses)
      should_see_mail_view
      sleep(0.4)
      addrs = addresses.split(/, ?/)
      addrs.each do |expected|
        unless email_to_contains? expected.strip
          screenshot_and_raise "expected to see '#{expected}' in the email 'to' field but found '#{email_to}'"
        end
      end
    end

    def is_ios5_mail_view
      query("layoutContainerView descendant view:'MFMailComposeView'").count == 1
    end

    def should_see_mail_view (opts = {:timeout => BRIAR_WAIT_TIMEOUT,
                                      :email_view_mark => 'compose email'})
      default_opts = {:timeout => BRIAR_WAIT_TIMEOUT,
                      :email_view_mark => 'compose email'}
      merged = default_opts.merge(opts)

      if email_not_testable?
        warn_about_no_ios5_email_view
        return
      end

      timeout = merged[:timeout]
      msg = "waited for '#{timeout}' seconds but did not see email compose view"
      #noinspection RubyParenthesesAfterMethodCallInspection

      email_view_mark = merged[:email_view_mark]
      wait_for(:timeout => timeout,
               :retry_frequency => BRIAR_WAIT_RETRY_FREQ,
               :post_timeout => BRIAR_WAIT_STEP_PAUSE,
               :timeout_message => msg) do
        if ios5?
          is_ios5_mail_view
        else
          view_exists? email_view_mark
        end
      end
    end

    #noinspection RubyResolve
    def device_can_send_email
      return true if simulator?
      if defined? backdoor_device_configured_for_mail?
        backdoor_device_configured_for_mail?
      else
        pending 'you will need to create a backdoor method to check if the device can send an email'
      end
    end

    def delete_draft_and_wait_for (view_id, opts={})

      if email_not_testable?
        warn_about_no_ios5_email_view
        return
      end

      default_opts = {:timeout => BRIAR_WAIT_TIMEOUT,
                      :email_view_mark => 'compose email'}
      opts = default_opts.merge(opts)

      # does a wait for iOS > 5 + uia available
      should_see_mail_view opts

      if ios5?
        touch_navbar_item_and_wait_for_view 'Cancel', 'Delete Draft'
        step_pause
        touch_sheet_button_and_wait_for_view 'Delete Draft', view_id
      else

        if ios6? or ios7?
          sbo = status_bar_orientation.to_sym

          if sbo.eql?(:left) or sbo.eql?(:right)
            pending "5 < iOS < 8 detected AND orientation '#{sbo}' - there is a bug in UIAutomation that prohibits touching the cancel button"
          end

          if sbo.eql?(:up) and ipad?
            pending "5 < iOS < 8 detected AND orientation '#{sbo}' AND ipad - there is a bug in UIAutomation prohibits touching the cancel button"
          end
        end

        timeout = BRIAR_WAIT_TIMEOUT
        msg = "waited for '#{timeout}' seconds but did not see cancel button"
        wait_for(:timeout => timeout,
                 :retry_frequency => BRIAR_WAIT_RETRY_FREQ,
                 :post_timeout => BRIAR_WAIT_STEP_PAUSE,
                 :timeout_message => msg) do
          uia_element_exists?(:view, {:marked => 'Cancel'})
        end

        uia_tap_mark('Cancel')
        msg = "waited for '#{timeout}' seconds but did not see dismiss email action sheet"
        wait_for(:timeout => timeout,
                 :retry_frequency => BRIAR_WAIT_RETRY_FREQ,
                 :post_timeout => BRIAR_WAIT_STEP_PAUSE,
                 :timeout_message => msg) do
            uia_element_exists?(:view, {:marked => 'Delete Draft'})
        end

        uia_tap_mark('Delete Draft')

        wait_for_view_to_disappear 'compose email'
      end
      step_pause
    end

    def uia_touch_email_to (opts={})
      default_opts = {:wait_for_keyboard => true}
      opts = default_opts.merge(opts)

      if uia_not_available?
        screenshot_and_raise 'UIA needs to be available'
      end

      # with predicate
      # uia_tap(:textField, {[:label, :beginswith] => "'To:'"})
      uia_tap(:textField, {:marked => 'toField'})
      uia_wait_for_keyboard if opts[:wait_for_keyboard]
    end

    def uia_set_email_to(addresses, opts={})
      default_opts = {:wait_for_keyboard => true}
      opts = default_opts.merge(opts)
      uia_touch_email_to opts
      addresses.each do |addr|
        uia_type_string addr
        uia_enter
        step_pause
      end
    end

    def uia_touch_send_email
      uia_tap_mark('Send')
    end

    def uia_send_email_to(addresses, opts={})
      default_opts = {:wait_for_keyboard => true}
      opts = default_opts.merge(opts)
      uia_set_email_to addresses, opts
      uia_touch_send_email
    end
  end
end
