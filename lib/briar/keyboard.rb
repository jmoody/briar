require "calabash-cucumber"

module Briar
  module Keyboard
    def should_see_keyboard
      res = element_exists("keyboardAutomatic")
      unless res
        screenshot_and_raise "Expected keyboard to be visible."
      end
    end

    def should_not_see_keyboard
      res = element_exists("keyboardAutomatic")
      if res
        screenshot_and_raise "Expected keyboard to not be visible."
      end
    end

    # is it possible to find what view the keyboard is responding to?
    def autocapitalization_type ()
      if !query("textView index:0").empty?
        query("textView index:0", :autocapitalizationType).first.to_i
      elsif !query("textField index:0").empty?
        query("textField index:0", :autocapitalizationType).first.to_i
      else
        screenshot_and_raise "could not find a text view or text field"
      end
    end

    UITextAutocapitalizationTypeNone = 0
    UITextAutocapitalizationTypeWords = 1
    UITextAutocapitalizationTypeSentences = 2
    UITextAutocapitalizationTypeAllCharacters = 3

    def is_capitalize_none (cap_type)
      cap_type == UITextAutocapitalizationTypeNone
    end

    def is_capitalize_words (cap_type)
      cap_type == UITextAutocapitalizationTypeWords
    end

    def is_capitalize_sentences (cap_type)
      cap_type == UITextAutocapitalizationTypeSentences
    end

    def is_capitalize_all (cap_type)
      cap_type == UITextAutocapitalizationTypeAllCharacters
    end
  end
end
