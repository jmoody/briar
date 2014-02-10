require 'awesome_print'
require 'ansi/logger'

@log = ANSI::Logger.new(STDOUT)

# returns a verbose simulator description key based on a canonical key
#
# using to control which simulator is launched
def simulator_hash
  {:iphone => 'iPhone Retina (3.5-inch)',
   :iphone_4in => 'iPhone Retina (4-inch)',
   :iphone_4in_64 => 'iPhone Retina (4-inch 64-bit)',
   :ipad => 'iPad',
   :ipad_r => 'iPad Retina',
   :ipad_r_64 => 'iPad Retina (64-bit)'}
end

# returns a canonical key for the current default simulator
def default_simulated_device
  res = `defaults read com.apple.iphonesimulator "SimulateDevice"`.chomp
  simulator_hash.each { |key, value|
    return key if res.eql?(value)
  }
  raise "could not find '#{res}' in hash values '#{simulator_hash()}'"
end

# kills the simulator if it is running
#
# uses Apple Script
def kill_simulator
  dev_dir = ENV['DEVELOPER_DIR']
  system "/usr/bin/osascript -e 'tell application \"#{dev_dir}/Platforms/iPhoneSimulator.platform/Developer/Applications/iPhone Simulator.app\" to quit'"
end

def open_simulator
  dev_dir = ENV['DEVELOPER_DIR']
  system "/usr/bin/osascript -e 'tell application \"#{dev_dir}/Platforms/iPhoneSimulator.platform/Developer/Applications/iPhone Simulator.app\" to activate'"
end


# sets the default simulator using a canonical key
#
#          :iphone # => 'iPhone Retina (3.5-inch)'
#      :iphone_4in # => 'iPhone Retina (4-inch)'
#   :iphone_4in_64 # => 'iPhone Retina (4-inch 64-bit)'
#            :ipad # => 'iPad'
#          :ipad_r # => 'iPad Retina'
#       :ipad_r_64 # => 'iPad Retina (64-bit)'
#
def set_default_simulator(device_key)
  hash = simulator_hash
  unless hash[device_key]
    raise "#{device_key} was not one of '#{hash.keys}'"
  end

  open_simulator
  current_device = default_simulated_device()
  unless current_device.eql?(device_key)
    value = hash[device_key]
    @log.info{"setting default simulator to '#{value}' using device key '#{device_key}'"}
    `defaults write com.apple.iphonesimulator "SimulateDevice" '"#{value}"'`
    kill_simulator
  end
  open_simulator
end


def briar_sim(args)
  arg_len = args.length
  if arg_len == 0
    ap simulator_hash
    exit 0
  end

  if arg_len > 1
    @log.warn{ "expected only 2 args but found '#{args}' - ignoring extra input" }
  end
  if arg_len == 1
    cmd = String.new(args[0])

    case cmd
      when 'quit'
        @log.info{ 'quiting the simulator' }
        kill_simulator
      when 'open'
        @log.info{ 'making simulator front-most app' }
        open_simulator
      else
        cmd.gsub!('-','_')
        cmd.gsub!(':','')
        sim_version = cmd.to_sym
        hash = simulator_hash
        unless hash[sim_version]
          @log.error{ "cannot convert '#{args[0]}' into a recognized simulator version" }
          @log.error{ "after coercing i found '#{cmd}'" }
          @log.error{ "expected one of '#{hash.keys}'" }
          exit 1
        end
        set_default_simulator sim_version
    end
  end
end





