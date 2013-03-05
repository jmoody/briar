require 'briar/gestalt'
require 'briar/briar_core'

require 'briar/alerts_and_sheets/alert_view'

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

World(Briar)
World(Briar::Core)
World(Briar::Alerts_and_Sheets)
World(Briar::Bars)
World(Briar::Control::Button)
World(Briar::Control::Segmented_Control)
World(Briar::Control::Slider)
World(Briar::Picker::Date)
World(Briar::Picker_Shared)
World(Briar::Picker)
World(Briar::Email)
World(Briar::ImageView)
World(Briar::Keyboard)
World(Briar::Label)
World(Briar::ScrollView)
World(Briar::Table)
World(Briar::TextField)
World(Briar::TextView)

AfterConfiguration do
  require 'briar/briar_steps'
end
