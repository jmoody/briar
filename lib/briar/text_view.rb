require "calabash-cucumber"

module Briar
  module TextView
    def text_view_exists? (name)
      !query("textView marked:'#{name}'").empty?
    end

    def should_see_text_view (name)
      unless text_view_exists? name
        screenshot_and_raise "i do not see text view with id #{name}"
      end
    end

    def should_not_see_text_view (name)
      if text_view_exists? name
        screenshot_and_raise "i should not see text view with name #{name}"
      end
    end
  end
end
