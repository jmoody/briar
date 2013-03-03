require 'calabash-cucumber'

module Briar
  module Bars
    def tabbar_visible?
      element_exists("tabBar")
    end

    def should_see_tabbar
      unless tabbar_visible?
        screenshot_and_raise "i do not see the tabbar"
      end
    end

    def index_of_tabbar_item(name)
      if tabbar_visible?
        tabs = query('tabBarButton', :accessibilityLabel)
        tabs.index(name)
      end
    end

    def touch_tabbar_item(name)
      idx = index_of_tabbar_item name
      puts "idx = '#{idx}'"
      if idx
        touch "tabBarButton index:#{idx}"
        step_pause
      else
        screenshot_and_raise "tabbar button with name #{name} does not exist"
      end
    end

    def tabbar_item_is_at_index(name, index)
      tabs = query('tabBarButton', :accessibilityLabel)
      tabs.index(name) == index.to_i
    end
  end
end

