require 'calabash-cucumber'

module Briar
  module Email

    def warn_about_ios6_email_view
      warn 'WARN: iOS6 detected - cannot test for email views on iOS simulator or devices'
    end

    def email_body
      query("view:'MFComposeTextContentView'", :text)
    end

    def email_body_contains? (text)
      if gestalt.is_ios6?
        warn 'WARN: iOS6 detected - cannot test for email body text https://groups.google.com/d/topic/calabash-ios/Ff3XFsjp-B0/discussion'
      else
        !query("view:'MFComposeTextContentView' {text LIKE '*#{text}*'}").empty?
      end
    end

    def email_subject
      query("view:'MFComposeSubjectView'", :text).first
    end

    def email_subject_is? (text)
      if gestalt.is_ios6?
        warn 'WARN: iOS6 detected - cannot test for email subject text https://groups.google.com/d/topic/calabash-ios/Ff3XFsjp-B0/discussion'
      else
        email_subject.eql? text
      end
    end

    def email_subject_has_text_like? (text)
      if gestalt.is_ios6?
        warn 'WARN: iOS6 detected - cannot test for email subject text https://groups.google.com/d/topic/calabash-ios/Ff3XFsjp-B0/discussion'
      else
        !query("view:'MFComposeSubjectView' {text LIKE '*#{text}*'}").empty?
      end
    end

    def email_to
      query("view:'_MFMailRecipientTextField'", :text).first
    end

    def email_to_field_is? (text)
      if gestalt.is_ios6?
        warn 'WARN: iOS6 detected - cannot test for email to field https://groups.google.com/d/topic/calabash-ios/Ff3XFsjp-B0/discussion'
      else
        email_to.eql? text
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
      gestalt.is_ios6?
    end

    def should_see_mail_view (timeout=1.0)
      if gestalt.is_ios6?
        screenshot_and_raise 'iOS6 detected - cannot test for email viewhttps://groups.google.com/d/topic/calabash-ios/Ff3XFsjp-B0/discussion'
      end

      msg = "waited for '#{timeout}' seconds but did not see email compose view"
      wait_for(:timeout => timeout,
               :retry_frequency => 0.2,
               :post_timeout => 0.1,
               :timeout_message => msg ) do
        is_ios5_mail_view
      end
    end

    def device_can_send_email
      return true if gestalt.is_simulator?
      backdoor('calabash_backdoor_configured_for_mail:', 'ignorable').eql? 'YES'
    end

    def delete_draft_and_wait_for (view_id)
      if gestalt.is_ios6?
        warn_about_ios6_email_view
      else
        should_see_mail_view
        touch_navbar_item 'Cancel'
        wait_for_animation
        touch_transition("button marked:'Delete Draft'",
                         "view marked:'#{view_id}'",
                         {:timeout=>TOUCH_TRANSITION_TIMEOUT,
                          :retry_frequency=>TOUCH_TRANSITION_RETRY_FREQ})
      end
    end
  end
end
