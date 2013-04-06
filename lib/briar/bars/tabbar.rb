require 'calabash-cucumber'

module Briar
  module Bars
    def tabbar_visible?
      element_exists('tabBar')
    end

    def should_see_tabbar
      unless tabbar_visible?
        screenshot_and_raise 'i should see the tabbar'
      end
    end

    def should_not_see_tabbar
      if tabbar_visible?
        screenshot_and_raise 'i should not see the tabbar'
      end
    end

    def index_of_tabbar_item(name)
      if tabbar_visible?
        tabs = query('tabBarButton', :accessibilityLabel)
        tabs.index(name)
      end
    end

    def touch_tabbar_item(name)
      should_see_tabbar
      idx = index_of_tabbar_item name
      if idx
        touch "tabBarButton index:#{idx}"
        step_pause
      else
        screenshot_and_raise "tabbar button with name #{name} does not exist"
      end
    end

    def should_see_tab_at_index(name, index)
      should_see_tabbar
      tabs = query('tabBarButton', :accessibilityLabel)
      unless tabs.index(name) == index.to_i
        screenshot_and_raise "should have seen tab named '#{name}' at index '#{index}' but found these: '#{tabs}'"
      end
    end

    def tabbar_item_is_at_index(name, index)
      pending "deprecated 0.0.6 - use should_see_tab_at_index '#{name}', '#{index}'"
    end
  end
end

