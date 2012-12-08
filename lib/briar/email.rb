require 'calabash-cucumber'

module Briar
  module Email
    def email_body_contains_text (text)
      actual_tokens = query("view:'MFComposeTextContentView'", :text).first.split("\n")
      actual_tokens.include?(text)
    end


    def is_ios5_mail_view ()
      access_ids = query("view", :accessibilityIdentifier)
      access_ids.member?("toField") || access_ids.member?("subjectField")
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
