require_relative './briar_dot_xamarin'
require_relative './briar_env'


require 'ansi/logger'
@log = ANSI::Logger.new(STDOUT)

# returns an iOS version string based on a canonical key
#
# the iOS version string is used to control which version of the simulator is
# launched.  use this to set the +SDK_VERSION+.
#
# IMPORTANT: launching an iOS 5 simulator is not support in Xcode 5 or greater
# IMPORTANT: Instruments 5.0 cannot be used to launch an app on an iOS 5 device
def sdk_versions
  {:ios5 => '5.1',
   :ios6 => '6.1',
   :ios7 => '7.0'}
end

# returns a hash with default arguments for various launch and irb functions
def default_console_opts
  {:sdk_version => sdk_versions[:ios7],
   :irbrc => ENV['IRBRC'] || './.irbrc',
   :bundle_exec =>  ENV['BUNDLE_EXEC'] == '1'
  }
end

def screenshot_path
  path = ENV['SCREENSHOT_PATH'] || './screenshots'
  # *** trailing slash required ***
  ENV['SCREENSHOT_PATH'] = "#{path}/"
  # make a screenshot directory if one does not exist
  FileUtils.mkdir(path) unless File.exists?(path)
  path
end

#noinspection RubyStringKeysInHashInspection
def logging_level
  {'DEBUG' => ENV['DEBUG'] || '1',
   'CALABASH_FULL_CONSOLE_OUTPUT' => ENV['CALABASH_FULL_CONSOLE_OUTPUT'] || '1'}
end

#noinspection RubyStringKeysInHashInspection
def simulator_variables(sdk_version)
  {'DEVICE_TARGET' => 'simulator',
   'SKD_VERSION' => sdk_version}
end

#noinspection RubyStringKeysInHashInspection
def device_variables(device)
  {'DEVICE_TARGET' => read_device_info(device, :udid),
   'DEVICE_ENDPOINT' => read_device_info(device, :ip),
   'BUNDLE_ID' => expect_bundle_id()
  }
end


# returns a string that can be use to launch a <tt>calabash-ios console</tt>
# that is configured using the opts hash
#
#   ios_console_cmd('neptune') # => a command to launch an irb against neptune
#
def ios_console_cmd(device, opts={})
  default_opts = default_console_opts()
  opts = default_opts.merge(opts)

  env = ["SCREENSHOT_PATH=#{screenshot_path}"]

  logging_level.each { |key,value|
    env << "#{key}=#{value}"
  }

  if device.eql? :simulator
    simulator_variables(opts[:sdk_version]).each { |key,value|
      env << "#{key}=#{value}"
    }
  else
    device_variables(device).each { |key,value|
      env << "#{key}=#{value}"
    }
  end

  env << "IRBRC=#{opts[:irbrc]}"
  env << 'bundle exec' if opts[:bundle_exec]
  env << 'irb'
  env.join(' ')
end

# starts a console using the opts hash
def console(device, opts={})

  ### unexpected ###
  # do not be tempted to use IRB.start
  # this can cause some terrible problems at > exit
  ##################

default_opts = default_console_opts()
  opts = default_opts.merge(opts)
  cmd = ios_console_cmd(device, opts)
  puts Rainbow(cmd).green
  exec cmd
end


def briar_console(args)
  arg_len = args.length
  if arg_len == 0
    print_console_help
    exit 0
  end

  where = args[0]

  sim = arg_len == 2 ? args[1] : nil

  case where
    when 'sim6'
      set_default_simulator sim.to_sym if sim
      console(:simulator, {:sdk_version => sdk_versions[:ios6]})
    when 'sim7'
      set_default_simulator sim.to_sym if sim
      console(:simulator, {:sdk_version => sdk_versions[:ios7]})
    else
      if arg_len != 1
        @log.warn { "expected only one arg but found '#{args}' - ignoring extra input" }
      end
      console(where)
  end
end