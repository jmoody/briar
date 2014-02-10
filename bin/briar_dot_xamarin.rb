require 'ansi/logger'

@log = ANSI::Logger.new(STDOUT)

# return the device info by reading and parsing the relevant file in the
# ~/.xamarin directory
#
#   read_device_info('neptune', :udid) # => reads the neptune udid (iOS)
#   read_device_info('earp', :ip)      # => reads the earp udid (iOS)
#   read_device_info('r2d2', :serial)  # => read the r2d2 serial number (android)
def read_device_info (device, kind)
  kind = kind.to_sym
  kinds = [:ip, :udid, :serial]
  unless kinds.include?(kind)
    raise "illegal argument '#{kind}' - must be one of '#{kinds}'"
  end

  path = File.expand_path("~/.xamarin/devices/#{device}/#{kind}")

  unless File.exist?(path)
    @log.fatal{"cannot read device information for '#{device}'"}
    @log.fatal{"file '#{path}' does not exist"}
    exit 1
  end

  begin
    IO.readlines(path).first.strip
  rescue Exception => e
    @log.fatal{"cannot read device information for '#{device}'"}
    @log.fatal{e}
    exit 1
  end
end

# return a +Hash+ of XTC device sets where the key is some arbitrary description
# and the value is a <tt>XTC device set</tt>
def read_device_sets(path='~/.xamarin/test-cloud/ios-sets.csv')
  ht = Hash.new
  begin
    File.read(File.expand_path(path)).split("\n").each do |line|
      # not 1.8 compat
      # unless line[0].eql?('#')
      unless line.chars.to_a.first.eql?('#')
        tokens = line.split(',')
        if tokens.count == 2
          ht[tokens[0].strip] = tokens[1].strip
        end
      end
    end
    ht
  rescue Exception => e
    @log.fatal{'cannot read device set information'}
    @log.fatal{e}
    exit 1
  end
end

def read_api_token(account_name)
  path = File.expand_path("~/.xamarin/test-cloud/#{account_name}")

  unless File.exist?(path)
    @log.fatal{"cannot read account information for '#{account_name}'"}
    @log.fatal{"file '#{path}' does not exist"}
    exit 1
  end

  begin
    IO.readlines(path).first.strip
  rescue Exception => e
    @log.fatal{"cannot read account information for '#{account_name}'"}
    @log.fatal{e}
    exit 1
  end
end
