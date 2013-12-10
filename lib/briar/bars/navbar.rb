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


    def should_not_see_navbar_button (name, is_ui_button=false)
      if is_ui_button
        qstr = "buttonLabel marked:'#{name}' parent navigationBar"
        timeout = 1.0
        msg = "waited for '#{timeout}' seconds but i still see '#{name}' in navigation bar"
        wait_for(:timeout => timeout,
                 :retry_frequency => BRIAR_WAIT_RETRY_FREQ,
                 :post_timeout => BRIAR_WAIT_STEP_PAUSE,
                 :timeout_message => msg) do
          element_does_not_exist qstr
        end
      else
        idx = index_of_navbar_button name
        unless idx.nil?
          screenshot_and_raise "i should not see a navbar button named #{name}"
        end
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
               :retry_frequency => BRIAR_WAIT_RETRY_FREQ,
               :post_timeout => BRIAR_WAIT_STEP_PAUSE) do
        not query('navigationItemButtonView first').empty?
      end
      touch('navigationItemButtonView first')
      step_pause
    end

    def go_back_and_wait_for_view (view)
      sleep(0.2)
      wait_for(:timeout => BRIAR_WAIT_TIMEOUT,
               :retry_frequency => BRIAR_WAIT_RETRY_FREQ) do
        not query('navigationItemButtonView first').empty?
      end

      touch_transition('navigationItemButtonView first',
                       "view marked:'#{view}'",
                       {:timeout => TOUCH_TRANSITION_TIMEOUT,
                        :retry_frequency => TOUCH_TRANSITION_RETRY_FREQ})
      step_pause
    end

    def touch_navbar_item(item_name, wait_for_view_id=nil)
      wait_for(:timeout => BRIAR_WAIT_TIMEOUT,
               :retry_frequency => BRIAR_WAIT_RETRY_FREQ) do
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

