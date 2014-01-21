#noinspection RubyResolve
require 'calabash-cucumber'

module Briar
  module Core

    def step_pause
      sleep(BRIAR_STEP_PAUSE)
    end

    def step_pause_if_xtc
      sleep(BRIAR_STEP_PAUSE) if xamarin_test_cloud?
    end

    def wait_for_animation
      _deprecated('0.1.3', "use any of the 'wait_*' functions instead", :warn)
      sleep(0.6)
    end

    def view_exists? (view_id)
      !query("view marked:'#{view_id}'").empty?
    end

    def should_see_view (view_id)
      unless view_exists? view_id
        screenshot_and_raise "should see view with id '#{view_id}'"
      end
    end

    def should_not_see_view (view_id)
      if view_exists? view_id
        screenshot_and_raise "should not see view with id '#{view_id}'"
      end
    end

    def view_exists_with_text? (text)
      element_exists("view text:'#{text}'")
    end

    def should_see_view_with_frame(view_id, frame)
      res = query("view marked:'#{view_id}'").first
      if res.empty?
        screenshot_and_raise "should see view with id '#{view_id}'"
      end
      actual = res['frame']
      ['x', 'y', 'width', 'height'].each { |key|
        avalue = actual[key]
        evalue = frame[key]
        screenshot_and_raise "#{view_id} should have '#{key}' '#{evalue}' but found '#{avalue}'"
      }
    end

    # todo refactor should_see_view_with_center to wait for view
    def should_see_view_with_center(view_id, center_ht)
      res = query("view marked:'#{view_id}'").first
      if res.nil?
        screenshot_and_raise "should see view with id '#{view_id}'"
      end

      actual_ht = {:x =>  res['rect']['center_x'].to_f, :y =>  res['rect']['center_y'].to_f}

      unless actual_ht == center_ht
        screenshot_and_raise "#{view_id} has center '#{actual_ht}' but should have center '#{center_ht}'"
      end
    end

    def should_see_view_with_text (text)
      res = view_exists_with_text? text
      unless res
        screenshot_and_raise "should see view with text '#{text}'"
      end
    end

    def touch_view(view_id)
      wait_for_view view_id
      touch("view marked:'#{view_id}'")
    end

    def touch_view_named(view_id)
      _deprecated('0.1.3', "use 'touch_view' instead", :warn)
      touch_view(view_id)
    end

    def touch_and_wait_for_view(view_id, view_to_wait_for, timeout=BRIAR_WAIT_TIMEOUT)
      touch_view(view_id)
      wait_for_view(view_to_wait_for, timeout)
    end

    def wait_opts(msg, timeout)
      {:timeout => timeout,
       :retry_frequency => BRIAR_WAIT_RETRY_FREQ,
       :post_timeout => BRIAR_WAIT_STEP_PAUSE,
       :timeout_message => msg}
    end

    def wait_for_view (view_id, timeout=BRIAR_WAIT_TIMEOUT)
      msg = "waited for '#{timeout}' seconds but did not see '#{view_id}'"
      wait_for(:timeout => timeout,
               :retry_frequency => BRIAR_WAIT_RETRY_FREQ,
               :post_timeout => BRIAR_WAIT_STEP_PAUSE,
               :timeout_message => msg) do
        view_exists? view_id
      end
    end

    def wait_for_query(qstr, timeout=BRIAR_WAIT_TIMEOUT)
      msg = "waited for '#{timeout}' seconds but did not see\n '#{qstr}'"
      wait_for(:timeout => timeout,
               :retry_frequency => BRIAR_WAIT_RETRY_FREQ,
               :post_timeout => BRIAR_WAIT_STEP_PAUSE,
               :timeout_message => msg) do
        !query(qstr).empty?
      end
    end

    def wait_for_custom_view (view_class, view_id, timeout=BRIAR_WAIT_TIMEOUT)
      msg = "waited for '#{timeout}' seconds but did not see '#{view_id}'"
      wait_for(:timeout => timeout,
               :retry_frequency => BRIAR_WAIT_RETRY_FREQ,
               :post_timeout => BRIAR_WAIT_STEP_PAUSE,
               :timeout_message => msg) do
        !query("view:'#{view_class}' marked:'#{view_id}'").empty?
      end
    end

    def touch_custom_view(view_class, view_id, timeout=BRIAR_WAIT_TIMEOUT)
      wait_for_custom_view view_class, view_id, timeout
      touch("view:'#{view_class}' marked:'#{view_id}'")
    end


    def touch_custom_view_and_wait_for_view(view_class, view_id, view_to_wait_for, timeout=BRIAR_WAIT_TIMEOUT)
      wait_for_custom_view view_class, view_id, timeout
      touch("view:'#{view_class}' marked:'#{view_id}'")
      wait_for_view view_to_wait_for, timeout
    end


    def wait_for_views(views, timeout=BRIAR_WAIT_TIMEOUT)
      msg = "waited for '#{timeout}' seconds but did not see '#{views}'"
      options = {:timeout => timeout,
                 :retry_frequency => BRIAR_WAIT_RETRY_FREQ,
                 :post_timeout => BRIAR_WAIT_STEP_PAUSE,
                 :timeout_message => msg}
      wait_for(options) do
        views.all? { |view_id| view_exists?(view_id) }
      end
    end

    def wait_for_view_to_disappear(view_id, timeout=BRIAR_WAIT_TIMEOUT)
      msg = "waited for '#{timeout}' seconds for '#{view_id}' to disappear but it is still visible"
      options = {:timeout => timeout,
                 :retry_frequency => BRIAR_WAIT_RETRY_FREQ,
                 :post_timeout => BRIAR_WAIT_STEP_PAUSE,
                 :timeout_message => msg}
      wait_for(options) do
        not view_exists? view_id
      end
    end

    def touch_and_wait_to_disappear(view_id, timeout=BRIAR_WAIT_TIMEOUT)
      touch_view(view_id)
      wait_for_view_to_disappear view_id, timeout
    end


    # backdoor helpers
    # canonical backdoor command: 'calabash_backdoor_handle_command'
    # selector key = :selector
    # args key = :args
    def send_backdoor_command(command, args=[])
      if args.empty?
        json = "{\":selector\" : \"#{command}\"}"
        return backdoor('calabash_backdoor_handle_command:', json)
      end

      array = args.kind_of?(Array) ? args : [args]
      json = "{\":selector\" : \"#{command}\", \":args\" : #{array}}"
      res = backdoor('calabash_backdoor_handle_command:', json)
      if res.eql?('ERROR: no matching selector')
        screenshot_and_raise "no matching backdoor selector found for '#{command}'"
      end
      res
    end

    def tokenize_list (list)
      tokens = list.split(/[,]|(and )/)
      stripped = tokens.map { |elm| elm.strip }
      stripped.delete_if { |elm| ['and', 'or', ''].include?(elm) }
    end


    # <b>DEPRECATED</b> since 0.9.163
    #
    # replaced with:
    # * calabash function <tt>default_device</tt>
    # * methods in <tt>calabash-cucumber/environment_helpers.rb</tt>
    # * briar function <tt>default_device_or_create</tt>
    def device
      msg = "use the calabash function 'default_device', one of the methods in calabash-cucumber/environment_helpers.rb', or briar's 'default_device_or_create'"
      _deprecated('0.9.163', msg, :warn)
      d = default_device_or_create()
      if d.nil?
        d = Calabash::Cucumber::Device.new(nil, server_version())
      end
      d
    end

    # returns the device that is currently being tested against
    #
    # returns the +device+ attr of <tt>Calabash::Cucumber::Launcher</tt> if
    # it is defined.  otherwise, creates a new <tt>Calabash::Cucumber::Device</tt>
    # by querying the server.
    #
    # raises an error if the server cannot be reached
    def default_device_or_create
      device = default_device()
      if device.nil?
        device = Calabash::Cucumber::Device.new(nil, server_version())
      end
      device
    end

  end
end


