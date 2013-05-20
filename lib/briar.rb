#$:.unshift File.dirname(__FILE__)

DEVICE_ENDPOINT = (ENV['DEVICE_ENDPOINT'] || 'http://localhost:37265')
AI = :accessibilityIdentifier
TOUCH_TRANSITION_TIMEOUT = 30.0
TOUCH_TRANSITION_RETRY_FREQ = 0.5

require 'briar/version'
require 'briar/gestalt'
require 'briar/briar_core'

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
require 'briar/picker/date_picker'

require 'briar/email'
require 'briar/image_view'
require 'briar/keyboard'
require 'briar/label'
require 'briar/scroll_view'

require 'briar/table'
require 'briar/text_field'
require 'briar/text_view'

def gestalt ()
  uri = URI("#{DEVICE_ENDPOINT}/version")
  res = Net::HTTP.get(uri)
  Briar::Gestalt.new(res)
end






