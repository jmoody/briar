require 'calabash-cucumber'

module Briar
  module TextField
    def text_field_exists? (name)
      !query("textField marked:'#{name}'").empty?
    end

    def should_see_text_field (name)
      res = text_field_exists? name
      unless res
        screenshot_and_raise "could not find text field with name #{name}"
      end
    end

    def should_not_see_text_field (name)
      res = text_field_exists? name
      if res
        screenshot_and_raise "i should not see text field with name #{name}"
      end
    end

    def button_in_text_field_is_clear? (text_field_id)
      ht = query("textField marked:'#{text_field_id}' child button child imageView", :frame).first
      return false if ht.nil?

      if device.ios7?
        ht['X'] == 2.5 and ht['Y'] == 2.5 and ht['Width'] == 14 and ht['Height'] == 14
      else
        ht['X'] == 0 and ht['Y'] == 0 and ht['Width'] == 19 and ht['Height'] == 19
      end
    end

    def should_see_clear_button_in_text_field (text_field_id)
      unless button_in_text_field_is_clear? text_field_id
        screenshot_and_raise "expected to see clear button in text field #{text_field_id}"
      end
    end

    def should_not_see_clear_button_in_text_field (text_field_id)
      if button_in_text_field_is_clear? text_field_id
        screenshot_and_raise "did NOT expected to see clear button in text field #{text_field_id}"
      end
    end

    def text_field_exists_with_text?(text_field, text)
      actual = query("textField marked:'#{text_field}'", :text).first
      actual.eql? text
    end

    def should_see_text_field_with_text (text_field, text)
      unless text_field_exists_with_text? text_field, text
        actual = query("textField marked:'#{text_field}'", :text).first
        screenshot_and_raise "i expected to see text field named '#{text_field}' with text '#{text}' but found '#{actual}'"
      end
    end

  end
end
