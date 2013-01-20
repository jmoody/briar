require 'calabash-cucumber'

module Briar
  module Bars
    def toolbar_button_exists? (name_or_id)
      # look for text button
      text_button_arr = query("toolbar child toolbarTextButton child button child buttonLabel", :text)
      has_text_button = text_button_arr.index(name_or_id) != nil
      # look for non_text button
      toolbar_button_arr = query("toolbar child toolbarButton", :accessibilityLabel)
      has_toolbar_button = toolbar_button_arr.index(name_or_id) != nil

      has_text_button or has_toolbar_button
    end

    def should_see_toolbar_button (name_or_id)
      res = toolbar_button_exists? name_or_id
      unless res
        screenshot_and_raise "could not see toolbar button with name '#{name_or_id}'"
      end
    end
  end
end
