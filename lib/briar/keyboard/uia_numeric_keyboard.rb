require 'calabash-cucumber'

module Briar
  module UIAKeyboard
    module Numeric

      def is_numeric_keyboard?(opts={})
        default_opts = {:await_keyboard => false}
        opts = default_opts.merge(opts)
        await_keyboard if opts[:await_keyboard]
        res = uia('UIATarget.localTarget().frontMostApp().keyboard().keys().length')['value']
        res == 12
      end

      def keyboard_send_numeric_backspace(opts={})
        default_opts = {:await_keyboard => false}
        opts = default_opts.merge(opts)
        await_keyboard if opts[:await_keyboard]
        if ios7?
          uia('UIATarget.localTarget().frontMostApp().keyboard().buttons()[0].tap()')
        else
          keyboard_enter_char 'Delete'
        end
      end

      def keyboard_send_backspace(opts={})
        default_opts = {:await_keyboard => false}
        opts = default_opts.merge(opts)
        await_keyboard if opts[:await_keyboard]
        if is_numeric_keyboard?
          keyboard_send_numeric_backspace
        else
          keyboard_send_backspace
        end
      end
    end
  end
end