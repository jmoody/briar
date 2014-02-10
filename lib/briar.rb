#$:.unshift File.dirname(__FILE__)

# will deprecate soon (starting 0.1.3)
TOUCH_TRANSITION_TIMEOUT = 30.0
TOUCH_TRANSITION_RETRY_FREQ = 0.5

# deprecated 0.1.3
# ANIMATION_PAUSE = (ENV['ANIMATION_PAUSE'] || 0.6).to_f

# see below for replacements
BRIAR_RETRY_FREQ=0.1
BRIAR_POST_TIMEOUT=0.5
##################

BRIAR_STEP_PAUSE = (ENV['STEP_PAUSE'] || 0.5).to_f

# we need an insanely long time out because of some changes in 0.9.163
#
# the waits succeed after a short amount of time (visually < 1 sec), but fail if
# the wait time out is too short (4s)
#
# 8 seconds works most of the time
# 10 seconds seems safe
# 14 seconds is safe
#
# the problem with a long time out is that during development you want the tests
# to fail fast.
BRIAR_WAIT_TIMEOUT = (ENV['WAIT_TIMEOUT'] || 14.0).to_f
BRIAR_WAIT_RETRY_FREQ = (ENV['RETRY_FREQ'] || 0.1).to_f

# 'post timeout' is the time to wait after a wait function returns true
# i think 'wait step pause' is a better variable name
BRIAR_WAIT_STEP_PAUSE = (ENV['POST_TIMEOUT'] || 0.5).to_f

#noinspection RubyConstantNamingConvention
AI = :accessibilityIdentifier
#noinspection RubyConstantNamingConvention
AL = :accessibilityLabel

require 'calabash-cucumber'

require 'briar/version'
require 'briar/briar_core'
require 'briar/uia/briar_uia'
require 'briar/uia/briar_ipad_emulation'

require 'briar/alerts_and_sheets/alert_view'
require 'briar/alerts_and_sheets/action_sheet'

require 'briar/bars/tabbar'
require 'briar/bars/navbar'
require 'briar/bars/toolbar'

require 'briar/control/button'
require 'briar/control/segmented_control'
require 'briar/control/slider'

require 'briar/picker/picker_shared'
require 'briar/picker/picker'
require 'briar/picker/date_picker_core'
require 'briar/picker/date_picker_manipulation'
require 'briar/picker/date_picker'

require 'briar/email'
require 'briar/image_view'

require 'briar/keyboard/keyboard'
require 'briar/keyboard/uia_keyboard'
require 'briar/keyboard/uia_keyboard_language'
require 'briar/keyboard/uia_numeric_keyboard'

require 'briar/label'
require 'briar/scroll_view'

require 'briar/table'
require 'briar/text_field'
require 'briar/text_view'

require 'briar/page/briar_page_helpers'
require 'briar/page/briar_page'

# date picker requires DateTime.to_time
if RUBY_VERSION.start_with?('1.8')
  require 'date'
  class DateTime

    def to_time
      str = self.strftime('%z')
      Time.send(:make_time, year, mon, day, hour, min, 0, nil, str, nil)
    end

  end

  class String

    def ord
      self[0]
    end

  end
end
