require 'calabash-cucumber'

module Briar
  module Email

    def email_body
      query("view:'MFComposeTextContentView'", :text)
    end

    def email_body_contains? (text)
      if gestalt.is_ios6?
        puts 'WARN:  cannot test for email body text on iOS 6 - see https://groups.google.com/d/topic/calabash-ios/Ff3XFsjp-B0/discussion'
      else
        !query("view:'MFComposeTextContentView' {text LIKE '*#{text}*'}").empty?
      end
    end

    def email_subject
      query("view:'MFComposeSubjectView'", :text).first
    end

    def email_subject_is? (text)
      if gestalt.is_ios6?
        puts 'WARN:  cannot test for email subject text on iOS 6 - see https://groups.google.com/d/topic/calabash-ios/Ff3XFsjp-B0/discussion'
      else
        email_subject.eql? text
      end
    end

    def email_subject_has_text_like? (text)
      if gestalt.is_ios6?
        puts 'WARN:  cannot test for email subject text on iOS 6 - see https://groups.google.com/d/topic/calabash-ios/Ff3XFsjp-B0/discussion'
      else
        !query("view:'MFComposeSubjectView' {text LIKE '*#{text}*'}").empty?
      end
    end

    def email_to
      query("view:'_MFMailRecipientTextField'", :text).first
    end

    def email_to_field_is? (text)
      if gestalt.is_ios6?
        puts "WARN: iOS6 detected - cannot test for email 'to' field on iOS simulator or devices"
      else
        email_to.eql? text
      end
    end

    def email_to_contains? (address)
      addrs = email_to.split(/, ?/)
      addrs.include? address
    end

    def is_ios5_mail_view
      query("layoutContainerView descendant view:'MFMailComposeView'").count == 1
    end

    def is_ios6_mail_view
      gestalt.is_ios6?
      # sometimes this is returning false
      # access_ids = query("view", :accessibilityIdentifier)
      # access_ids.member?("RemoteViewBridge")
    end

    def should_see_mail_view
      wait_for_animation
      unless is_ios5_mail_view || is_ios6_mail_view
        screenshot_and_raise 'expected to see email view'
      end
    end
  end
end
