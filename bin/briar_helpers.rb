require 'briar'

BRIAR_RM_CAL_TARGETS='rm-cal-targets'
BRIAR_INSTALL_CALABASH_GEM='calabash-gem'
BRIAR_INSTALL_CALABASH_SERVER='calabash-server'
BRIAR_INSTALL_GEM='gem'
BRIAR_RESIGN_IPA='resign'
BRIAR_VERSION_CMD='version'

BRIAR_CMD_INSTALL='install'


def print_usage
  puts <<EOF
  briar #{Briar::VERSION}

  briar #{BRIAR_VERSION_CMD}
    print the current briar version

  briar #{BRIAR_RM_CAL_TARGETS}
    WARN: this is a destructive operation!
          * deletes all *-cal targets from simulator
          you have been warned.
    searches the ~/Library/Application Support/iPhone Simulator for *-cal.app
    targets and deletes the enclosing directory.  useful for clearing out old
    calabash targets when the framework needs to be updated.

  briar #{BRIAR_CMD_INSTALL} { gem | calabash-gem | calabash-server }
    subcommand to perform various installation tasks

  briar #{BRIAR_CMD_INSTALL} #{BRIAR_INSTALL_GEM}
    looks for ~/git/briar and runs 'rake install'. useful for developing and
    testing the briar gem

  briar #{BRIAR_CMD_INSTALL} #{BRIAR_INSTALL_CALABASH_GEM}
    looks for ~/git/calabash-ios/calabash-cucumber directory and runs
    'rake install' to install the calabash-cucumber gem.  useful for developing
    and testing the calabash-cucumber gem.

  briar #{BRIAR_CMD_INSTALL} #{BRIAR_INSTALL_CALABASH_SERVER}
    WARN: this is a destructive operation!
          * replaces calabash.framework in current directory
          * deletes all *-cal targets from simulator
          you have been warned.

    builds and installs the calabash server using calabash-cucumber rake task
    'rake rake build_server', removes all *-cal targets from simulator, and
    replaces calabash.framework in local directory.  useful for developing and
    testing the calabash-ios-server.

   briar: #{BRIAR_RESIGN_IPA} (experimental)
EOF
end
