require 'calabash-cucumber'

module Briar
  module Bars
    def navbar_visible?
      !query('navigationBar').empty?
    end

    def should_see_navbar
      unless navbar_visible?
        screenshot_and_raise 'should see the nav bar'
      end
    end

    def should_not_see_navbar
      if navbar_visible?
        screenshot_and_raise 'should not see the nav bar'
      end
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
      titles = query('navigationButton', AL)
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
      items = query('navigationItemView', AL)
      items.include?(with_leading) || items.include?(without_leading)
    end


    def go_back_after_waiting
      sleep(0.2)
      wait_for(:timeout => 1.0,
               :retry_frequency => 0.2) do
        not query('navigationItemButtonView first').empty?
      end
      touch('navigationItemButtonView first')
      step_pause
    end

    def go_back_and_wait_for_view (view)
      sleep(0.2)
      wait_for(:timeout => 1.0,
               :retry_frequency => 0.2) do
        not query('navigationItemButtonView first').empty?
      end

      touch_transition('navigationItemButtonView first',
                       "view marked:'#{view}'",
                       {:timeout=>TOUCH_TRANSITION_TIMEOUT,
                        :retry_frequency=>TOUCH_TRANSITION_RETRY_FREQ})
      step_pause
    end

    def touch_navbar_item(item_name, wait_for_view_id=nil)
      wait_for(:timeout => 1.0,
               :retry_frequency => 0.4) do
        (index_of_navbar_button(item_name) != nil) || button_exists?(item_name)
      end
      sleep(0.2)
      idx = index_of_navbar_button item_name

      if idx
        touch("navigationButton index:#{idx}")
        unless wait_for_view_id.nil?
          wait_for_view wait_for_view_id
        end
        step_pause
      elsif button_exists? item_name
        touch_button_and_wait_for_view item_name, wait_for_view_id
      else
        screenshot_and_raise "could not find navbar item '#{item_name}'"
      end
    end


    def touch_navbar_item_and_wait_for_view(item_name, view_id)
      touch_navbar_item item_name, view_id
    end


    def navbar_has_title? (title)
      sleep(0.2)
      query('navigationItemView', AL).include?(title)
    end

    def should_see_navbar_with_title(title)
      unless navbar_has_title? title
        screenshot_and_raise "after waiting, i did not see navbar with title #{title}"
      end
    end


    def navbar_should_have_title(title)
      pending "deprecated 0.0.6 - use should_see_navbar_with_title '#{title}'"
    end
  end
end

