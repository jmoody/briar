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
      tabs = query('tabBarButton', AL)
      tabs.index(name)
    end

    def touch_tabbar_item(name, wait_for_view_id=nil)
      sleep(0.2)
      wait_for(:timeout => BRIAR_WAIT_TIMEOUT,
               :retry_frequency => BRIAR_WAIT_RETRY_FREQ) do
        index_of_tabbar_item(name) != nil
      end
      should_see_tabbar
      idx = index_of_tabbar_item name
      if idx
        touch "tabBarButton index:#{idx}"
        unless wait_for_view_id.nil?
          wait_for_view wait_for_view_id
        end
        step_pause
      else
        screenshot_and_raise "tabbar button with name #{name} does not exist"
      end
    end

    def should_see_tab_at_index(name, index)
      should_see_tabbar
      tabs = query('tabBarButton', AL)
      unless tabs.index(name) == index.to_i
        screenshot_and_raise "should have seen tab named '#{name}' at index '#{index}' but found these: '#{tabs}'"
      end
    end
  end
end

