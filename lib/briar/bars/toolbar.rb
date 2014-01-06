require 'calabash-cucumber'

module Briar
  module Bars

    def toolbar_qstr(toolbar_id=nil)
      if toolbar_id.nil?
        'toolbar'
      else
        "toolbar marked:'#{toolbar_id}'"
      end
    end

    def toolbar_exists? (id)
      !query("toolbar marked:'#{id}'").empty?
    end

    def should_see_toolbar (toolbar_id, timeout=BRIAR_WAIT_TIMEOUT)
      wait_for_toolbar(toolbar_id, timeout)
    end

    def should_not_see_toolbar (toolbar_id, timeout=BRIAR_WAIT_TIMEOUT)
      wait_for_toolbar_to_disappear toolbar_id, timeout
      screenshot_and_raise "did not expect to see toolbar with id '#{toolbar_id}'" if toolbar_exists? toolbar_id
    end

    def toolbar_button_exists?(button_id, opts={:toolbar_id => nil})
      toolbar_id = opts[:toolbar_id]
      if toolbar_id.nil?
        not query("toolbar descendant view marked:'#{button_id}'").empty?
      else
        not query("toolbar marked:'#{toolbar_id}' descendant view marked:'#{button_id}'").empty?
      end

      # the problem here is that toolbar buttons come in many different flavors
      ## look for text button
      #text_button_arr = query("toolbar child toolbarTextButton child button child buttonLabel", :text)
      #has_text_button = text_button_arr.index(name_or_id) != nil
      ## look for non_text button
      #toolbar_button_arr = query("toolbar child toolbarButton", AL)
      #has_toolbar_button = toolbar_button_arr.index(name_or_id) != nil
      #
      #has_text_button or has_toolbar_button
    end

    def wait_for_toolbar_button(button_id, opts={})
      default_opts = {:timeout => BRIAR_WAIT_TIMEOUT,
                      :toolbar_id => nil}
      opts = default_opts.merge(opts)
      timeout=opts[:timeout]
      toolbar_id = opts[:toolbar_id]
      if toolbar_id.nil?
        msg = "waited for '#{timeout}' seconds but did not see toolbar button marked: '#{button_id}'"
      else
        msg = "waited for '#{timeout}' seconds but did not see toolbar button marked: '#{button_id}' in toolbar '#{toolbar_id}'"
      end

      options = {:timeout => timeout,
                 :retry_frequency => BRIAR_WAIT_RETRY_FREQ,
                 :post_timeout => BRIAR_WAIT_STEP_PAUSE,
                 :timeout_message => msg}
      wait_for(options) do
        toolbar_button_exists? button_id, opts
      end

    end

    def should_see_toolbar_button (button_id, opts={:timeout => BRIAR_WAIT_TIMEOUT,
                                                    :toolbar_id => nil})
      wait_for_toolbar_button button_id, opts
    end

    def wait_for_toolbar_to_disappear(toolbar_id, timeout=BRIAR_WAIT_TIMEOUT)
      msg = "waited for '#{timeout}' seconds but i still see toolbar marked: '#{toolbar_id}'"
      options = {:timeout => timeout,
                 :retry_frequency => BRIAR_WAIT_RETRY_FREQ,
                 :post_timeout => BRIAR_WAIT_STEP_PAUSE,
                 :timeout_message => msg}

      wait_for(options) do
        not toolbar_exists? toolbar_id
      end
    end


    def wait_for_toolbar(toolbar_id, timeout=BRIAR_WAIT_TIMEOUT)
      msg = "waited for '#{timeout}' seconds but did not see toolbar marked: '#{toolbar_id}'"
      options = {:timeout => timeout,
                 :retry_frequency => BRIAR_WAIT_RETRY_FREQ,
                 :post_timeout => BRIAR_WAIT_STEP_PAUSE,
                 :timeout_message => msg}
      wait_for(options) do
        toolbar_exists? toolbar_id
      end

    end


    def touch_toolbar_button(button_id, opts={})

      if opts.is_a?(Hash)
        default_opts ={:wait_for_view => nil,
                       :timeout => BRIAR_WAIT_TIMEOUT,
                       :toolbar_id => nil}
        opts = default_opts.merge(opts)
      else
        _deprecated('0.1.2',
                   "second argument should be a hash - found '#{opts}'",
                   :warn)
        opts = {:wait_for_view => opts[:wait_for_view],
                :timeout => BRIAR_WAIT_TIMEOUT,
                :toolbar_id => nil}
      end

      should_see_toolbar_button button_id, opts

      toolbar_qstr = toolbar_qstr(opts[:toolbar_id])
      touch("#{toolbar_qstr} descendant view marked:'#{button_id}'")

      wait_for_view = opts[:wait_for_view]
      unless wait_for_view.nil?
        timeout = opts[:timeout]
        msg = "touched '#{button_id}' and waited for '#{timeout}' sec but did not see '#{wait_for_view}'"
        options = {:timeout => timeout,
                   :retry_frequency => BRIAR_WAIT_RETRY_FREQ,
                   :post_timeout => BRIAR_WAIT_STEP_PAUSE,
                   :timeout_message => msg}
        wait_for(options) do
          view_exists? wait_for_view
        end
      end
    end
  end
end
