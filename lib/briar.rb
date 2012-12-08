$:.unshift File.dirname(__FILE__)

require "briar/version"
require "briar/gestalt"
require "briar/briar_core"

require "briar/alerts_and_sheets/alert_view"

require "briar/bars/tabbar"
require "briar/bars/navbar"
require "briar/bars/toolbar"

require "briar/control/button"
require "briar/control/segmented_control"
require "briar/control/slider"

require "briar/picker/picker_shared"
require "briar/picker/picker"
require "briar/picker/date_picker"

require "briar/email"
require "briar/image_view"
require "briar/keyboard"
require "briar/label"
require "briar/scroll_view"

require "briar/table"
require "briar/text_field"
require "briar/text_view"

require File.join(File.dirname(__FILE__), '..','features','step_definitions', "briar_core_steps")

require File.join(File.dirname(__FILE__), '..','features','step_definitions',"alerts_and_sheets", "action_sheet_steps")
require File.join(File.dirname(__FILE__), '..','features','step_definitions',"alerts_and_sheets", "alert_view_steps")

require File.join(File.dirname(__FILE__), '..','features','step_definitions',"bars", "tabbar_steps")
require File.join(File.dirname(__FILE__), '..','features','step_definitions',"bars", "navbar_steps")
require File.join(File.dirname(__FILE__), '..','features','step_definitions',"bars", "toolbar_steps")

require File.join(File.dirname(__FILE__), '..','features','step_definitions',"control", "button_steps")
require File.join(File.dirname(__FILE__), '..','features','step_definitions',"control", "segmented_control_steps")
require File.join(File.dirname(__FILE__), '..','features','step_definitions',"control", "slider_steps")


require File.join(File.dirname(__FILE__), '..','features','step_definitions',"picker", "picker_steps")
require File.join(File.dirname(__FILE__), '..','features','step_definitions',"picker", "date_picker_steps")


require File.join(File.dirname(__FILE__), '..','features','step_definitions',"email_steps")
require File.join(File.dirname(__FILE__), '..','features','step_definitions',"image_view_steps")
require File.join(File.dirname(__FILE__), '..','features','step_definitions',"keyboard_steps")
require File.join(File.dirname(__FILE__), '..','features','step_definitions',"label_steps")
require File.join(File.dirname(__FILE__), '..','features','step_definitions',"scroll_view_steps")

require File.join(File.dirname(__FILE__), '..','features','step_definitions',"table_steps")
require File.join(File.dirname(__FILE__), '..','features','step_definitions',"text_field_steps")
require File.join(File.dirname(__FILE__), '..','features','step_definitions',"text_view_steps")







