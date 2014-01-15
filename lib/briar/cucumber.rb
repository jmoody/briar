require 'require_relative'

require_relative '../briar'

World(Briar)
World(Briar::Core)
World(Briar::UIA)
World(Briar::UIA::IPadEmulation)
World(Briar::Alerts_and_Sheets)
World(Briar::Bars)
World(Briar::Control::Button)
World(Briar::Control::Segmented_Control)
World(Briar::Control::Slider)
World(Briar::Picker_Shared)
World(Briar::Picker)
World(Briar::Picker::DateCore)
World(Briar::Picker::DateManipulation)
World(Briar::Picker::DateSteps)
World(Briar::Email)
World(Briar::ImageView)
World(Briar::Keyboard)
World(Briar::UIAKeyboard)
World(Briar::UIAKeyboard::Numeric)
World(Briar::UIAKeyboard::Language)
World(Briar::Label)
World(Briar::ScrollView)
World(Briar::Table)
World(Briar::TextField)
World(Briar::TextView)


require_relative '../../features/step_definitions/alerts_and_sheets/action_sheet_steps'
require_relative '../../features/step_definitions/alerts_and_sheets/alert_view_steps'

require_relative '../../features/step_definitions/bars/tabbar_steps'
require_relative '../../features/step_definitions/bars/navbar_steps'
require_relative '../../features/step_definitions/bars/toolbar_steps'

require_relative '../../features/step_definitions/control/button_steps'
require_relative '../../features/step_definitions/control/segmented_control_steps'
require_relative '../../features/step_definitions/control/slider_steps'


require_relative '../../features/step_definitions/picker/picker_steps'
require_relative '../../features/step_definitions/picker/date_picker_steps'


require_relative '../../features/step_definitions/email_steps'
require_relative '../../features/step_definitions/image_view_steps'
require_relative '../../features/step_definitions/keyboard_steps'
require_relative '../../features/step_definitions/label_steps'
require_relative '../../features/step_definitions/scroll_view_steps'

require_relative '../../features/step_definitions/table_steps'
require_relative '../../features/step_definitions/text_field_steps'
require_relative '../../features/step_definitions/text_view_steps'
