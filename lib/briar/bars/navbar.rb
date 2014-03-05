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
      res = query('navigationItemButtonView')
      return false if res.empty?

      # sometime the back button is there, but has zero rect
      frame = res.first['frame']

      ['x', 'y', 'width', 'height'].each { |key|
        if frame[key] != 0
          return true
        end
      }
      false
    end

    def should_see_navbar_back_button
      timeout = BRIAR_WAIT_TIMEOUT * 2.0
      msg = "waited for '#{timeout}' seconds but did not see navbar back button"
      wait_for(:timeout => timeout,
               :retry_frequency => BRIAR_WAIT_RETRY_FREQ,
               :post_timeout => BRIAR_WAIT_STEP_PAUSE,
               :timeout_message => msg) do
        navbar_has_back_button?
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

    # bar_button_type options =>
    # button    <= the button is a UIButton
    # bar_item  <= the button is UIBarButtonItem
    def should_see_navbar_button (mark, opts={})
      default_opts = {:bar_button_type => :bar_item,
                      :timeout => BRIAR_WAIT_TIMEOUT}
      opts = default_opts.merge(opts)
      if opts[:bar_button_type] == :button
        queries = ["buttonLabel marked:'#{mark}' parent navigationBar",
                   "button marked:'#{mark}' parent navigationBar"]
        timeout = opts[:timeout]
        msg = "waited for '#{timeout}' seconds but did not see '#{mark}' in navigation bar"
        wait_for(:timeout => timeout,
                 :retry_frequency => BRIAR_WAIT_RETRY_FREQ,
                 :post_timeout => BRIAR_WAIT_STEP_PAUSE,
                 :timeout_message => msg) do
          queries.any? { |query| element_exists query }
        end
      else
        idx = index_of_navbar_button mark
        if idx.nil?
          # check to see if it is a ui button
          should_see_navbar_button mark, {:bar_button_type => :button}
        end
      end
    end


    # todo convert args to hash and mirror the should_see_navbar_button
    #is_ui_button=false)
    def should_not_see_navbar_button (mark, opts={})
      if (not opts.is_a?(Hash)) and (not opts.nil?)
        warn "\nWARN: deprecated 0.1.4 - you should no longer pass a Boolean '#{opts}' as an arg, pass opts hash instead"
        button_type = opts ? :button : :bar_item
        opts = {:bar_button_type => button_type}
      end
      default_opts = {:bar_button_type => :bar_item,
                      :timeout => BRIAR_WAIT_TIMEOUT}
      opts = default_opts.merge(opts)
      if opts[:bar_button_type] == :button
        queries = ["buttonLabel marked:'#{mark}' parent navigationBar",
                   "button marked:'#{mark}' parent navigationBar"]
        timeout = opts[:timeout]
        msg = "waited for '#{timeout}' seconds but i still see '#{mark}' in navigation bar"
        wait_for(:timeout => timeout,
                 :retry_frequency => BRIAR_WAIT_RETRY_FREQ,
                 :post_timeout => BRIAR_WAIT_STEP_PAUSE,
                 :timeout_message => msg) do
          queries.all? { |query| element_does_not_exist query }
        end
      else
        idx = index_of_navbar_button mark
        unless idx.nil?
          # check to see if it is a ui button
          should_not_see_navbar_button mark, {:bar_button_type => :button}
        end
      end
    end

    def date_is_in_navbar (date)
      with_leading = date.strftime('%a %b %d')
      without_leading = date.strftime("%a %b #{date.day}")
      items = query('navigationItemView', AL)
      items.include?(with_leading) || items.include?(without_leading)
    end


    def go_back_after_waiting(opts={})
      default_opts = {:wait_before_going_back => 0.2,
                      :timeout => BRIAR_WAIT_TIMEOUT,
                      :timeout_message => nil,
                      :wait_step_pause => BRIAR_WAIT_STEP_PAUSE,
                      :retry_frequency => BRIAR_WAIT_RETRY_FREQ}
      opts = default_opts.merge(opts)
      wait_before = opts[:wait_before_going_back]
      sleep(wait_before)

      msg = opts[:timeout_message]
      timeout = opts[:timeout]
      if msg.nil?
        msg = "waited for '#{timeout + wait_before}' for navbar back button but didn't see it"
      end

      wait_for(:timeout => timeout,
               :retry_frequency => opts[:retry_frequency],
               :post_timeout => opts[:wait_step_pause],
               :timeout_message => msg) do
        not query('navigationItemButtonView first').empty?
      end
      touch('navigationItemButtonView first')
      step_pause
    end

    def go_back_and_wait_for_view (view)
      sleep(0.2)
      timeout = BRIAR_WAIT_TIMEOUT
      msg = "waited '#{timeout}' seconds but did not see navbar back button"
      wait_for(wait_opts(msg, timeout)) do
        not query('navigationItemButtonView first').empty?
      end

      touch_transition('navigationItemButtonView first',
                       "view marked:'#{view}'",
                       {:timeout => TOUCH_TRANSITION_TIMEOUT,
                        :retry_frequency => TOUCH_TRANSITION_RETRY_FREQ})
      step_pause
    end

    def touch_navbar_item(item_name, wait_for_view_id=nil)
      timeout = BRIAR_WAIT_TIMEOUT
      msg = "waited '#{timeout}' seconds for nav bar item '#{item_name}' to appear"

      wait_for(wait_opts(msg, timeout)) do
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
      all_items = query("navigationItemView marked:'#{title}'")
      button_items = query('navigationItemButtonView')
      non_button_items = all_items.delete_if { |item| button_items.include?(item) }
      !non_button_items.empty?
    end

    def should_see_navbar_with_title(title, timeout=BRIAR_WAIT_TIMEOUT)
      msg = "waited for '#{timeout}' seconds but i did not see #{title} in navbar"
      wait_for(:timeout => timeout,
               :retry_frequency => BRIAR_WAIT_RETRY_FREQ,
               :post_timeout => BRIAR_WAIT_STEP_PAUSE,
               :timeout_message => msg) do
        navbar_has_title? title
      end
    end
  end
end

