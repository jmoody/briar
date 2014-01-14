require 'calabash-cucumber'

module Briar
  module UIA
    module IPadEmulation

      class Cache

        attr_accessor :window_index

        def initialize
          @window_index = nil
        end


      end
      # use the apple localization codes
      BRIAR_IPAD_1X_2X_BUTTON_LABELS = {
            :en => {:emulated_1x => 'Switch to full screen mode',
                    :emulated_2x => 'Switch to normal mode'}
      }

      def ensure_uia_and_ipad()
        unless ipad?
          screenshot_and_raise 'this function is only for the iPad'
        end

        unless ios7?
          screenshot_and_raise 'this function only works on iOS 7'
        end

        unless uia_available?
          screenshot_and_raise 'this function requires the app be launched with instruments'
        end
      end


      def ipad_1x_2x_labels_hash(lang_code)
        ht = BRIAR_IPAD_1X_2X_BUTTON_LABELS[lang_code]
        if ht.nil?
          screenshot_and_raise "did not recognize language code '#{lang_code}'"
        end
        ht
      end

      def ipad_1x_2x_labels_array(lang_code)
        ht = ipad_1x_2x_labels_hash lang_code
        [ht[:emulated_1x], ht[:emulated_2x]]
      end

      def uia_ipad_scale(opts={})
        default_opts = {:language_code => :en,
                        :ensure_uia_and_ipad => false,
                        :cache => Cache.new}
        opts = default_opts.merge(opts)

        if opts[:ensure_uia_and_ipad]
          ensure_uia_and_ipad()
          opts[:ensure_uia_and_ipad] = false
        end


        idx = window_index_of_ipad_1x_2x_button opts

        res = uia("UIATarget.localTarget().frontMostApp().windows()[#{idx}].buttons()[0].label()")
        val = res['value']

        candidates = ipad_1x_2x_labels_array(opts[:language_code])

        if val.eql?(candidates[0])
          :emulated_1x
        else
          :emulated_2x
        end
      end


      def is_iphone_app_emulated_on_ipad?(cache=Cache.new)
        return false unless ipad?
        idx = window_index_of_ipad_1x_2x_button({:raise_if_not_found => false,
                                                 :cache => cache})
        idx != -1
      end

      def window_index_of_ipad_1x_2x_button(opts={})

        default_opts = {:language_code => :en,
                        :ensure_uia_and_ipad => false,
                        :raise_if_not_found => true,
                        :cache => Cache.new}
        opts = default_opts.merge(opts)

        cache = opts[:cache]
        return cache.window_index unless cache.window_index.nil?


        ensure_uia_and_ipad() if opts[:ensure_uia_and_ipad]

        window_count = uia('UIATarget.localTarget().frontMostApp().windows().length')['value']
        index = 0

        lang_code = opts[:language_code]
        candidates = ipad_1x_2x_labels_array(lang_code)
        success = false
        loop do
          res = uia("UIATarget.localTarget().frontMostApp().windows()[#{index}].buttons()[0].label()")
          if candidates.include?(res['value'])
            success = true
            break
          end
          index = index + 1
          break unless index < window_count
        end

        unless success
          if opts[:raise_if_not_found]
            screenshot_and_raise "could not find window with button label '#{candidates[0]}' or '#{candidates[1]}' - is your an iphone app emulated on an ipad?"
          end
          index = -1
        end
        cache.window_index = index
        index
      end

      def uia_tap_ipad_scale_button(opts={})
        default_opts = {:language_code => :en,
                        :ensure_uia_and_ipad => false,
                        :step_pause_after_touch => BRIAR_STEP_PAUSE,
                        :cache => Cache.new}
        opts = default_opts.merge(opts)
        ensure_uia_and_ipad() if opts[:ensure_uia_and_ipad]

        idx = window_index_of_ipad_1x_2x_button(opts)
        uia("UIATarget.localTarget().frontMostApp().windows()[#{idx}].buttons()[0].tap()")
        sleep(opts[:step_pause_after_touch])
      end


      def ensure_ipad_emulation_scale(scale, opts={})
        allowed = [:emulated_1x, :emulated_2x]
        unless allowed.include?(scale)
          screenshot_and_raise "'#{scale}' is not one of '#{allowed}' allowed args"
        end

        cache = Cache.new
        #noinspection RubyParenthesesAfterMethodCallInspection
        return unless is_iphone_app_emulated_on_ipad?(cache)

        default_opts = {:language_code => :en,
                        :ensure_uia_and_ipad => false,
                        :step_pause_after_touch => BRIAR_STEP_PAUSE,
                        :cache => cache}
        opts = default_opts.merge(opts)

        actual_scale = uia_ipad_scale(opts)

        if actual_scale != scale
          uia_tap_ipad_scale_button opts
        end
      end

      def ensure_ipad_emulation_1x(opts={})
        default_opts = {:language_code => :en,
                        :ensure_uia_and_ipad => false,
                        :step_pause_after_touch => BRIAR_STEP_PAUSE,
                        :cache => Cache.new}
        opts = default_opts.merge(opts)
        ensure_ipad_emulation_scale(:emulated_1x, opts)
      end

      def ensure_ipad_emulation_2x(opts={})
        default_opts = {:language_code => :en,
                        :ensure_uia_and_ipad => false,
                        :step_pause_after_touch => BRIAR_STEP_PAUSE,
                        :cache => Cache.new}
        opts = default_opts.merge(opts)
        ensure_ipad_emulation_scale(:emulated_2x, opts)
      end

    end
  end
end