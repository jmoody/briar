require 'json'

module Briar
  GESTALT_IPHONE = 'iPhone'
  GESTALT_IPAD = 'iPad'
  GESTALT_IPHONE5 = 'Retina 4-inch'
  GESTALT_SIM_SYS = 'x86_64'
  GESTALT_IPOD = 'iPod'


  class Gestalt

    attr_reader :device_family
    attr_reader :simulator_details, :ios_version
    attr_reader :system
    attr_reader :framework_version

    def initialize (json)
      ht = JSON.parse json
      simulator_device = ht['simulator_device']
      @system = ht['system']
      @device_family = @system.eql?(GESTALT_SIM_SYS) ? simulator_device : @system.split(/[\d,.]/).first
      @simulator_details = ht['simulator']
      @ios_version = ht['iOS_version']
      @framework_version = ht['version']
    end

    def is_simulator?
      self.system.eql?(GESTALT_SIM_SYS)
    end

    def is_device?
      not self.is_simulator?
    end

    def is_iphone?
      self.device_family.eql? GESTALT_IPHONE
    end

    def is_ipod?
      self.device_family.eql? GESTALT_IPOD
    end

    def is_ipad?
      self.device_family.eql? GESTALT_IPAD
    end

    def is_iphone_5?
      return self.simulator_details.split(/[(),]/)[3].eql? GESTALT_IPHONE5 if self.is_simulator?
      return self.system.split(/[\D]/).delete_if { |x| x.eql?('') }.first.eql?('5') if self.is_device?
    end

    def version_hash (version_str)
      tokens = version_str.split(/[,.]/)
      {:major_version => tokens[0],
       :minor_version => tokens[1],
       :bug_version => tokens[2]}
    end

    def ios_major_version
      self.version_hash(self.ios_version)[:major_version]
    end

    def is_ios7?
      self.version_hash(self.ios_version)[:major_version].eql?('7')
    end

    def is_ios6?
      self.version_hash(self.ios_version)[:major_version].eql?('6')
    end

    def is_ios5?
      self.version_hash(self.ios_version)[:major_version].eql?('5')
    end
  end
end

#{"outcome":"SUCCESS","app_name":"Rise Up CAL","iOS_version":"5.1.1","app_version":"1.0","system":"iPad1,1","app_id":"org.recoverywarrriors.RiseUp-cal","version":"0.9.125"}=> true

#  "iPhone Simulator 358.4, iPhone OS 6.0 (iPhone (Retina 4-inch)\/10A403)".split(/[(),]/)
#  => ["iPhone Simulator 358.4", " iPhone OS 6.0 ", "iPhone ", "Retina 4-inch", "/10A403"]

#  system ("curl --insecure #{url}")
#  {"outcome":"SUCCESS","app_name":"Rise Up CAL","simulator_device":"iPhone","iOS_version":"6.0",
#"app_version":"1.0","system":"x86_64","app_id":"org.recoverywarrriors.RiseUp-cal",
#"version":"0.9.126","simulator":"iPhone Simulator 358.4, iPhone OS 6.0 (iPhone (Retina 4-inch)\/10A403)"}=> true

#{"outcome":"SUCCESS","app_name":"Rise Up CAL","iOS_version":"6.0.1","app_version":"1.0",
#"system":"iPhone4,1","app_id":"org.recoverywarrriors.RiseUp-cal","version":"0.9.125"}


