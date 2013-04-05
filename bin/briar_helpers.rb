require 'briar'

BRIAR_RM_CAL_TARGETS='rm-cal-targets'

def print_usage
  puts <<EOF
  briar #{Briar::VERSION}
  Usage: briar #{BRIAR_RM_CAL_TARGETS}
    WARN: this is a destructive operation! you have been warned.
    searches the ~/Library/Application Support/iPhone Simulator for *-cal.app
    targets and deletes the enclosing directory.  useful for clearing out old
    calabash targets when the framework needs to be updated.
EOF
end
