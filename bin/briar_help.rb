require 'briar'
require 'rainbow'
require 'ansi/code'
require 'ansi/string'
require 'ansi/mixin'
require 'ansi/columns'

# these have been deprecated since 0.1.3
BRIAR_RM_CAL_TARGETS='rm-cal-targets'
BRIAR_INSTALL_CALABASH_GEM='calabash-gem'
BRIAR_INSTALL_CALABASH_SERVER='calabash-server'
BRIAR_INSTALL_GEM='gem'
BRIAR_RESIGN_IPA='resign'
BRIAR_VERSION_CMD='version'
BRIAR_CMD_INSTALL='install'

def warn_deprecated(version, msg)
  puts ANSI.cyan { "deprecated'#{version}' - '#{msg}'" }
end

def help_warn_destructive
  Rainbow('# These is are destructive operations! You have been warned.').red.underline
end

def help_experimental
  Rainbow('EXPERIMENTAL').underline.magenta
end

def help_not_available_ruby18
  Rainbow('RUBY > 1.8').underline.magenta
end

def help_deprecated(version, msg)
  ANSI.cyan { "DEPRECATED #{version} - #{msg}" }
end

def help_nyi
  ANSI.yellow { 'NYI' }
end

def help_command(sig)
  Rainbow("briar #{sig}").cyan
end

def help_requires_env_vars
  Rainbow('REQUIRES ENV VARIABLES').magenta
end

def help_env_var(name, msg)
  "#{Rainbow(name).yellow} => #{msg}"
end

def help_examples
  'EXAMPLES'
end

def help_example_comment(comment)
  Rainbow("# #{comment}").magenta
end

def help_example(example)
  Rainbow("$ briar #{example}").cyan
end

def help_requires_dot_xamarin
  Rainbow('REQUIRES adopting .xamarin convention.').magenta
end

def help_see_dot_xamarin_help
  "see #{Rainbow('$ briar help .xamarin').yellow} for details"
end

def help_requires_xtc_profiles
  Rainbow('REQUIRES xtc-profiles.yml').magenta
end

def help_see_xtc_profiles_help
  "see #{Rainbow('$ briar help xtc-profiles').yellow} for details"
end

def help_customize
  Rainbow('CUSTOMIZATION').green
end

def help_requires_cucumber_profiles
  Rainbow('REQUIRES cucumber profiles').magenta
end

def help_see_cucumber_reports_help
  "see #{Rainbow('$ briar help cucumber-reports').yellow} for details"
end

def print_dot_xamarin_help
  puts <<EOF

#{Rainbow('THE PITCH').cyan.underline}

The .xamarin convention helps manage devices, projects, and XTC accounts by
stashing all of your calabash configuration details in one place.

* Do you have more than one device?
* More that one calabash project?
* Are you working cross-platform?
* Are your device IP address not stable?
* Do you have an XTC account?

If you answered yes to any of those questions, .xamarin will improve your
workflow.

https://github.com/jmoody/briar/wiki/The-.xamarin-Convention

EOF
end

def print_version_help
  puts <<EOF
#{Rainbow('are you serious?').cyan}
EOF
end

def print_rm_help
  puts <<EOF
#{help_command('rm sim-targets')}
  deletes all *-cal targets from simulator
  useful for clearing out old calabash targets when the framework has been updated.

#{help_command('rm dups [project-prefix]')}
  deletes duplicate directories from your Xcode DerivedData directory

  helps resolves problems with calabash detecting the #{Rainbow('APP_BUNDLE_PATH').yellow}

  #{help_requires_env_vars}
  #{help_env_var('       DERIVED_DATA', 'defaults to "${HOME}/Library/Developer/Xcode/DerivedData')}
  #{help_env_var('DERIVED_DATA_PREFIX', 'must be set or project-prefix must be passed as arg')}

  #{help_examples}
  #{help_example_comment('raises an error if DERIVED_DATA_PREFIX is not defined')}
  #{help_example('rm dups')}
  #{help_example('rm dups Briar')}
  #{help_example('rm dups briar-ios-example')}

#{help_warn_destructive}

EOF
end

def print_install_help
  puts <<EOF
#{help_command('install calabash-server')}
  1. builds the calabash server using calabash-cucumber #{Rainbow('$ rake task :build_server').cyan}
  2. replaces calabash.framework in the current directory,
  3. removes all *-cal targets from simulator, and
  4. removes duplicate derived data directories

  #{help_requires_env_vars}
  #{help_env_var('CALABASH_SERVER_PATH', 'top level directory of your local calabash-ios-server repo')}
  #{help_env_var('   CALABASH_GEM_PATH', 'top level directory of your local calabash-ios repo')}

  #{help_examples}
  #{help_example_comment('raises an error if calabash server and gem paths are not defined')}
  #{help_example('install calabash-server')}

#{help_command('install < device-name >')}
  do a clean install of an .ipa on device

  if #{Rainbow("ENV['IPA_BUILD_SCRIPT']").yellow} is defined, this command will call that script
  to generate an .ipa.

  #{help_requires_dot_xamarin}
  #{help_see_dot_xamarin_help}

  #{help_requires_env_vars}
  #{help_env_var('                 IPA', 'path to the .ipa you want installed')}
  #{help_env_var('           BUNDLE_ID', 'bundle id of the app - eg. com.littlejoysoftware.Briar-cal')}
  #{help_env_var('IDEVICEINSTALLER_BIN', 'path to ideviceinstaller binary')}
  #{help_env_var('    IPA_BUILD_SCRIPT', '(optional) script that generates the IPA')}

#{help_warn_destructive}

EOF
end

def print_console_help
  puts <<EOF
#{help_command('console { sim6 | sim7 } [simulator version]}')}
  starts a calabash console targeting a specific sdk

  optionally sets the simulator version

  #{help_examples}
  #{help_example('sim6')}
  #{help_example('sim6 iphone_4in')}
  #{help_example('sim7 ipad_r')}
  #{help_example('sim7 iphone_4in_64')}

#{help_command('<device name>')}
  start a calabash console against a physical device

  #{help_requires_dot_xamarin}
  #{help_see_dot_xamarin_help}

  #{help_examples}
  #{help_example('console venus')}

#{help_customize}
#{help_example_comment('you can customize the console using these variables')}
#{help_env_var('             SCREENSHOT_PATH', 'where to put console screenshots - defaults to ./screenshots')}
#{help_env_var('                       DEBUG', 'verbose logging')}
#{help_env_var('CALABASH_FULL_CONSOLE_OUTPUT', 'verboser logging')}
#{help_env_var('                       IRBRC', 'location of custom .irbrc file - defaults to ./.irbrc')}
#{help_env_var('                 BUNDLE_EXEC', 'start console with bundle exec - defaults to 0')}

#{help_not_available_ruby18}
EOF
end

def print_resign_help
  puts <<EOF

#{help_experimental}

#{help_command('resign </path/to/your.ipa> </path/to/your.mobileprovision> <wildcard-prefix> <signing-identity>')}

EOF
end

def print_cucumber_reports_help
  puts <<EOF
#{Rainbow('USE CUCUMBER PROFILES TO GENERATE REPORTS').cyan.underline}

#{help_example_comment('example cucumber.yml')}
#{Rainbow("<%

date = Time.now.strftime('%Y-%m-%d-%H%M-%S')
default_report = \"./reports/calabash-\#{date}.html\"
FileUtils.mkdir(\"./reports\") unless File.exists?(\"./reports\")

%>

html_report:  -f 'Calabash::Formatters::Html' -o <%= default_report %>
default:      -p html_report").yellow}

#{help_example_comment('run wip tests on iOS 7 simulator and then open the results')}
#{Rainbow('$ cucumber -t @wip').cyan}
#{Rainbow('$ briar report').cyan}

For a more complete example see:

https://github.com/jmoody/briar-ios-example/blob/master/Briar/cucumber.yml

#{help_example_comment('run keyboard tests on the iOS 6 simulator using sim launch then open the results')}
#{Rainbow('$ cucumber -p sim6 -p launch -t @keyboard').cyan}
#{Rainbow('$ briar report').cyan}

#{help_example_comment('run table view tests on venus (an iOS 7 iPad 4)then open the the results')}
#{Rainbow('$ cucumber -p venus -t @table').cyan}
#{Rainbow('$ briar report').cyan}

EOF
end

def print_report_help
  puts <<EOF

#{help_requires_cucumber_profiles}
#{help_see_cucumber_reports_help}

#{help_command('report')}
 opens the most recent cucumber report generated by a run against the simulator in the default browser

#{help_command('report <device>')}
 opens the most recent cucumber report generated by a run against < device > in the default browser

  #{help_requires_dot_xamarin}
  #{help_see_dot_xamarin_help}

EOF
end

def print_sim_help
  puts <<EOF
#{help_command('sim')}
  prints the available simulators

#{help_command('sim quit')}
  quits the simulator

#{help_command('sim open')}
  makes the simulator the front-most app

#{help_command('sim <simulator version>')}
  quits the simulator and sets the default simulator to <simulator version>

  #{help_examples}
  #{help_example('sim iphone_4in')}
  #{help_example('sim ipad_r')}
  #{help_example('sim iphone_4in_64')}
EOF

end

def print_xtc_help
  puts <<EOF

#{help_experimental}

#{help_requires_dot_xamarin}
#{help_see_dot_xamarin_help}

#{help_requires_xtc_profiles}
#{help_see_xtc_profiles_help}

#{help_command('xtc')}
  prints the available XTC device sets


#{help_command('xtc <device-set> [profile]')} #{help_experimental}
  submits a job to the XTC targeting devices specified in < device-set >
  if no profile is set, the 'default' profile in the xtc-cucumber.yml will be used

#{help_command('xtc <device-set> <profile> [build args]')} #{help_experimental}
  submits a job to the XTC targeting devices specified in < device-set > using
  the cucumber profile specified by < profile >.  you can optionally pass build
  arguments to to control your xamarin build script.

  #{help_requires_env_vars}
  #{help_env_var('                 IPA', 'path to the .ipa you submitting')}
  #{help_env_var('        XTC_PROFILES', 'cucumber profiles for the XTC')}
  #{help_env_var('         XTC_ACCOUNT', 'name of a directory in ~/.xamarin/test-cloud/<account> that contains the api token')}
  #{help_example_comment('if a build script is defined, the .ipa will be built before submission')}
  #{help_env_var('    IPA_BUILD_SCRIPT', '(optional) script that generates the IPA')}
  #{help_example_comment('if you require other gems besides briar')}
  #{help_env_var(' XTC_OTHER_GEMS_FILE', 'path to a file describing other gems that should be installed on the XTC')}
  #{help_env_var('   XTC_BRIAR_GEM_DEV', "set to '1' to ensure the local version of briar will be uploaded to the XTC'")}
  #{help_env_var('XTC_CALABASH_GEM_DEV', "set to '1' to ensure the local version of calabash will be uploaded to the XTC'")}

EOF
end

def print_xtc_profiles_help
  puts <<EOF
#{Rainbow('MOTIVATION').cyan.underline}

Let's face it. Your development cucumber.yml is probably a mess.  Plus, your
XTC goals are a different. Use different set of cucumber profiles for the XTC.

#{help_example_comment('example xtc-cucumber.yml')}
#{Rainbow('# careful using the @not_xtc tag - you should avoid not running tests!
# use for Scenario Outlines which are nyi on XTC
not_xtc:     --tags ~@not_xtc
not_sim:     --tags ~@simulator --tags ~@simulator_only
no_launch:   --tags ~@no_launch

tags:        -p not_xtc -p not_sim -p no_launch
default:     -p tags

wip:         -p tags --tags @wip
').yellow}

For a more complex example see:

https://github.com/jmoody/briar-ios-example/blob/master/Briar/features/xtc-profiles.yml

To take advantage of the #{Rainbow('briar xtc <device-set> [profile]').yellow}
command, set the #{Rainbow('XTC_PROFILES').cyan} variable to your xtc-profiles.yml

EOF
end

def print_tags_help
  puts <<EOF
#{help_command('tags')} #{help_experimental}
 generates a cucumber tag report

 requires list_tags.rb in features/support/ directory

EOF
end

def print_usage
  puts <<EOF
#{Rainbow("Welcome to briar #{Briar::VERSION}!").cyan}

briar help { command } for more information a command

 console { sim6 [simulator version] | sim7 [simulator version] | <device-name> } #{help_experimental}
 install { calabash-server | <device-name> }
  report [device]
  resign #{help_experimental}
      rm { sim-targets | dups [project-name] }
     sim [{quit | <simulator version>}] #{help_experimental}
    tags #{help_experimental}
 version
     xtc { [<device-set> [profile]] | [<device-set> <profile> [build args] } #{help_experimental}

#{Rainbow('ADDITIONAL HELP TOPICS').green}
     help .xamarin
     help cucumber-reports
     help xtc-profiles

#{Rainbow('DEPRECATED').yellow}
* #{Rainbow(BRIAR_RM_CAL_TARGETS).yellow} #{help_deprecated('0.1.3', 'replaced with $ briar rm sim-targets')}
* #{Rainbow("#{BRIAR_CMD_INSTALL} #{BRIAR_INSTALL_GEM}").yellow} #{help_deprecated('0.1.3', 'will be removed')}
* #{Rainbow("#{BRIAR_CMD_INSTALL} #{BRIAR_INSTALL_CALABASH_GEM}").yellow} #{help_deprecated('0.1.3', 'will be removed')}

EOF
end
