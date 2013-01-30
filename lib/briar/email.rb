require 'calabash-cucumber'

module Briar
  module Email
    def email_body_first_line_is? (text)
      if gestalt.is_ios6?
        puts "WARN:  cannot test for email body text on iOS 6 - see https://groups.google.com/d/topic/calabash-ios/Ff3XFsjp-B0/discussion"
      else
        actual_tokens = query("view:'MFComposeTextContentView'", :text).first.split("\n")
        actual_tokens.include?(text)
      end
    end

    def email_subject_is? (text)
      if gestalt.is_ios6?
        puts "WARN:  cannot test for email subject text on iOS 6 - see https://groups.google.com/d/topic/calabash-ios/Ff3XFsjp-B0/discussion"
      else
        actual = query("view marked:'subjectField'", :text)
        actual.length == 1 && actual.first.eql?(text)
      end
    end

    def email_subject_has_text_like? (text)
      if gestalt.is_ios6?
        puts "WARN:  cannot test for email subject text on iOS 6 - see https://groups.google.com/d/topic/calabash-ios/Ff3XFsjp-B0/discussion"
      else
        !query("view marked:'subjectField' {text LIKE '*#{text}*'}").empty?
      end
    end

    def email_to_field_is? (text)
      if gestalt.is_ios6?
        puts "WARN: iOS6 detected - cannot test for email 'to' field on iOS simulator or devices"
      else
        actual = query("view marked:'toField'", :text)
        actual.length == 1 && actual.first.eql?(text)
      end
    end

    def is_ios5_mail_view ()
      query("view:'MFMailComposeRecipientView'").count == 3
      #access_ids = query("view", :accessibilityIdentifier)
      #access_ids.member?("toField") || access_ids.member?("subjectField")
    end

    def is_ios6_mail_view()
      access_ids = query("view", :accessibilityIdentifier)
      access_ids.member?("RemoteViewBridge")
    end

    def should_see_mail_view
      wait_for_animation
      unless is_ios5_mail_view || is_ios6_mail_view
        screenshot_and_raise "expected to see email view"
      end
    end
  end
end
