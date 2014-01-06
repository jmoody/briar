require 'calabash-cucumber'

module Briar
  module UIAKeyboard
    module Numeric

      def is_numeric_keyboard?(opts={})
        if uia_not_available?
          pending('this feature is nyi')
        end
        default_opts = {:wait_for_keyboard => false}
        opts = default_opts.merge(opts)
        wait_for_keyboard if opts[:wait_for_keyboard]
        res = uia('UIATarget.localTarget().frontMostApp().keyboard().keys().length')['value']
        res == 12
      end

      def keyboard_send_numeric_backspace(opts={})
        default_opts = {:wait_for_keyboard => false}
        opts = default_opts.merge(opts)
        wait_for_keyboard if opts[:wait_for_keyboard]
        if uia_available?
          uia('UIATarget.localTarget().frontMostApp().keyboard().buttons()[0].tap()')
        else
          keyboard_enter_char 'Delete'
        end
      end

      def keyboard_send_backspace(opts={})
        default_opts = {:wait_for_keyboard => false}
        opts = default_opts.merge(opts)
        wait_for_keyboard if opts[:wait_for_keyboard]
        if is_numeric_keyboard?
          keyboard_send_numeric_backspace
        else
          keyboard_enter_char 'Delete'
        end
      end
    end
  end
end

