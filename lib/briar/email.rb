require 'calabash-cucumber'

module Briar
  module Email

    def email_testable?
      return true if device.ios5?
      uia_available?
    end

    def email_not_testable?
      not email_testable?()
    end

    def warn_about_no_ios5_email_view
      warn 'WARN: iOS > 5 detected - cannot test for email views on iOS simulator or devices unless we use UIAutomation'
    end

    def email_body
      query("view:'MFComposeTextContentView'", :text)
    end

    def email_body_contains? (text)
      if device.ios5?
        !query("view:'MFComposeTextContentView' {text LIKE '*#{text}*'}").empty?
      else
        warn 'WARN: iOS > 5 detected - cannot test for email body text'
      end
    end

    def email_subject
      query("view:'MFComposeSubjectView'", :text).first
    end

    def email_subject_is? (text)
      if device.ios5?
        email_subject.eql? text
      else
        warn 'WARN: iOS > 5 detected - cannot test for email subject text'
      end
    end

    def email_subject_has_text_like? (text)
      if device.ios5?
        !query("view:'MFComposeSubjectView' {text LIKE '*#{text}*'}").empty?
      else
        warn 'WARN: iOS > 5 detected - cannot test for email subject text'
      end
    end

    def email_to
      query("view:'_MFMailRecipientTextField'", :text).first
    end

    def email_to_field_is? (text)
      if device.ios5?
        email_to.eql? text
      else
        warn 'WARN: iOS > 5 detected - cannot test for email to field'
      end
    end

    def email_to_contains? (address)
      addrs = email_to.split(/, ?/)
      addrs.include? address
    end

    def should_see_recipients (addresses)
      should_see_mail_view
      wait_for_animation
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

    def is_ios6_mail_view
      warn 'WARN: deprected 0.0.9'
    end

    def should_see_mail_view (timeout=BRIAR_WAIT_TIMEOUT)
      if email_not_testable?
        warn_about_no_ios5_email_view
        return
      end

      msg = "waited for '#{timeout}' seconds but did not see email compose view"
      dev = device()
      wait_for(:timeout => timeout,
               :retry_frequency => 0.2,
               :post_timeout => 0.1,
               :timeout_message => msg ) do
        if dev.ios5?
          is_ios5_mail_view
        else
          view_exists? 'compose email'
        end
      end
    end

    def device_can_send_email
      return true if device.simulator?
      backdoor_device_configured_for_mail?
    end

    def delete_draft_and_wait_for (view_id)
      if email_not_testable?
        warn_about_no_ios5_email_view
        return
      end

      # does a wait for iOS > 5 + uia available
      should_see_mail_view

      device = device()

      if device.ios5?
        touch_navbar_item_and_wait_for_view 'Cancel', 'Delete Draft'
        step_pause
        touch_sheet_button_and_wait_for_view 'Delete Draft', view_id
      else
        sbo = status_bar_orientation.to_sym

        if sbo.eql?(:left) or sbo.eql?(:right)
          pending "iOS > 5 detected AND orientation '#{sbo}' - there is a bug in UIAutomation that prohibits touching the cancel button"
        end

        # might also occur on devices, but i don't know
        if sbo.eql?(:up) and device.ipad? and device.simulator?
          pending "iOS > 5 detected AND orientation '#{sbo}' AND simulator - there is a bug in UIAutomation prohibits touching the cancel button"
        end

        timeout = BRIAR_WAIT_TIMEOUT * 2
        msg = "waited for '#{timeout}' seconds but did not see cancel button"
        wait_for(:timeout => timeout,
                 :retry_frequency => 1.1,
                 :post_timeout => 0.1,
                 :timeout_message => msg ) do
          uia_element_exists?(:view, marked:'Cancel')
        end

        uia_tap_mark('Cancel')
        msg = "waited for '#{timeout}' seconds but did not see dismiss email action sheet"
        wait_for(:timeout => timeout,
                 :retry_frequency => 1.1,
                 :post_timeout => 0.1,
                 :timeout_message => msg ) do
          uia_element_exists?(:view, marked:'Delete Draft')
        end

        uia_tap_mark('Delete Draft')

        wait_for_view_to_disappear 'compose email'
      end
      step_pause
    end
  end
end
