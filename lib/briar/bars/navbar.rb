require 'calabash-cucumber'

module Briar
  module Bars
    def navbar_visible?
      !query('navigationBar').empty?
    end

    def navbar_has_back_button?
          !query('navigationItemButtonView').empty?
    end

    def should_see_navbar_back_button
      unless navbar_has_back_button?
        screenshot_and_raise 'there is no navigation bar back button'
      end
    end

    def should_not_see_navbar_back_button
      if navbar_has_back_button?
        screenshot_and_raise 'i should not see navigation bar back button'
      end
    end


    # will not work to detect left/right buttons
    def index_of_navbar_button (name)
      titles = query('navigationButton', :accessibilityLabel)
      titles.index(name)
    end

    def should_see_navbar_button (name)
      idx = index_of_navbar_button name
      if idx.nil?
        screenshot_and_raise "there should be a navbar button named '#{name}'"
      end
    end

    def should_not_see_navbar_button (name)
      idx = index_of_navbar_button name
      unless idx.nil?
        screenshot_and_raise "i should not see a navbar button named #{name}"
      end
    end

    def date_is_in_navbar (date)
      with_leading = date.strftime('%a %b %d')
      without_leading = date.strftime("%a %b #{date.day}")
      items = query('navigationItemView', :accessibilityLabel)
      items.include?(with_leading) || items.include?(without_leading)
    end


    def go_back_after_waiting
      wait_for_animation
      touch('navigationItemButtonView first')
      step_pause
    end

    def go_back_and_wait_for_view (view)
      wait_for_animation
      touch_transition('navigationItemButtonView first',
                       "view marked:'#{view}'",
                       {:timeout=>TOUCH_TRANSITION_TIMEOUT,
                        :retry_frequency=>TOUCH_TRANSITION_RETRY_FREQ})
    end

    def touch_navbar_item(name)
      wait_for_animation
      idx = index_of_navbar_button name
      #puts "index of nav bar button: #{idx}"
      if idx
        touch("navigationButton index:#{idx}")
        step_pause
      else
        screenshot_and_raise "could not find navbar item '#{name}'"
      end
    end


    def touch_navbar_item_and_wait_for_view(item, view)
      wait_for_animation
      idx = index_of_navbar_button item
      touch_transition("navigationButton index:#{idx}",
                       "view marked:'#{view}'",
                       {:timeout=>TOUCH_TRANSITION_TIMEOUT,
                        :retry_frequency=>TOUCH_TRANSITION_RETRY_FREQ})
    end


    def navbar_has_title (title)
      wait_for_animation
      query('navigationItemView', :accessibilityLabel).include?(title)
    end

    def navbar_should_have_title(title)
      unless navbar_has_title title
        screenshot_and_raise "after waiting, i did not see navbar with title #{title}"
      end
    end

  end
end

