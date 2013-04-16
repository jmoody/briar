require_relative './../spec_helper'
require_relative './../../lib/briar/gestalt'

module Briar
  SIM__IPHONE_5__IOS_6_JSON = "{\"outcome\":\"SUCCESS\",\"app_name\":\"Rise Up CAL\",\"simulator_device\":\"iPhone\",\"iOS_version\":\"6.0\",\"app_version\":\"1.0\",\"system\":\"x86_64\", \"app_id\":\"org.recoverywarrriors.RiseUp-cal\",\"version\":\"0.9.126\", \"simulator\":\"iPhone Simulator 358.4, iPhone OS 6.0 (iPhone (Retina 4-inch)\/10A403)\"}"
  DEVICE__IPHONE_4__IOS_6_JSON = "{\"outcome\":\"SUCCESS\",\"app_name\":\"Rise Up CAL\",\"iOS_version\":\"6.0.1\",\"app_version\":\"1.0\",\"system\":\"iPhone4,1\",\"app_id\":\"org.recoverywarrriors.RiseUp-cal\",\"version\":\"0.9.125\"}"
  DEVICE__IPHONE_5__IOS_6_JSON = "{\"outcome\":\"SUCCESS\",\"app_name\":\"Rise Up CAL\",\"iOS_version\":\"6.0.1\",\"app_version\":\"1.0\",\"system\":\"iPhone5,0\",\"app_id\":\"org.recoverywarrriors.RiseUp-cal\",\"version\":\"0.9.125\"}"
  DEVICE__IPAD1__IOS_5_JSON = "{\"outcome\":\"SUCCESS\",\"app_name\":\"Rise Up CAL\",\"iOS_version\":\"5.1.1\",\"app_version\":\"1.0\",\"system\":\"iPad1,1\",\"app_id\":\"org.recoverywarrriors.RiseUp-cal\",\"version\":\"0.9.125\"}"
  DEVICE__IPOD4G__IOS__5_JSON = "{\"outcome\":\"SUCCESS\",\"app_name\":\"Badoo\",\"simulator_device\":\"\",\"iOS_version\":\"5.1.1\",\"app_version\":\"2.2.1\",\"system\":\"iPod4,1\",\"app_id\":\"com.badoo.Badoo\",\"version\":\"0.9.126\",\"simulator\":\"\"}"

  describe 'Gestalt' do
    before(:each) do
      @sim_iphone_5_ios6 = Gestalt.new(SIM__IPHONE_5__IOS_6_JSON)
      @device_iphone4_ios6 = Gestalt.new(DEVICE__IPHONE_4__IOS_6_JSON)
      @device_iphone5_ios6 = Gestalt.new(DEVICE__IPHONE_5__IOS_6_JSON)
      @device_ipad1_ios5 = Gestalt.new(DEVICE__IPAD1__IOS_5_JSON)
      @device_ipod4_ios5 = Gestalt.new(DEVICE__IPOD4G__IOS__5_JSON)
    end

    it 'has the ios major version' do
      @sim_iphone_5_ios6.is_ios6?.should == true
      @sim_iphone_5_ios6.is_ios5?.should == false

      @device_iphone4_ios6.is_ios6?.should == true
      @device_iphone4_ios6.is_ios5?.should == false

      @device_ipad1_ios5.is_ios6?.should == false
      @device_ipad1_ios5.is_ios5?.should == true

      @device_ipod4_ios5.is_ios5?.should == true
      @device_ipod4_ios5.is_ios6?.should == false
    end


    it 'can tell the simulator from device' do
      @sim_iphone_5_ios6.is_simulator?.should == true
      @sim_iphone_5_ios6.is_device?.should == false

      @device_iphone4_ios6.is_simulator?.should == false
      @device_iphone4_ios6.is_device?.should == true

      @device_ipad1_ios5.is_simulator?.should == false
      @device_ipad1_ios5.is_device?.should == true

      @device_ipod4_ios5.is_simulator?.should == false
      @device_ipod4_ios5.is_device?.should == true

    end

    it 'has the device family' do
      @sim_iphone_5_ios6.is_iphone?.should == true
      @sim_iphone_5_ios6.is_ipad?.should == false
      @sim_iphone_5_ios6.is_ipod?.should == false


      @device_iphone4_ios6.is_iphone?.should == true
      @device_iphone4_ios6.is_ipad?.should == false
      @device_iphone4_ios6.is_ipod?.should == false

      @device_ipad1_ios5.is_iphone?.should == false
      @device_ipad1_ios5.is_ipad?.should == true
      @device_ipad1_ios5.is_ipod?.should == false

      @device_ipod4_ios5.is_iphone?.should == false
      @device_ipod4_ios5.is_ipad?.should == false
      @device_ipod4_ios5.is_ipod?.should == true

    end

    it 'can identify iphone 5' do
      @sim_iphone_5_ios6.is_iphone_5?.should == true
      @device_iphone4_ios6.is_iphone_5?.should == false
      @device_iphone5_ios6.is_iphone_5?.should == true
      @device_ipad1_ios5.is_iphone_5?.should == false
      @device_ipod4_ios5.is_iphone_5?.should == false
    end

    it 'has correct framework version' do
      @sim_iphone_5_ios6.framework_version.should == '0.9.126'
      @device_iphone4_ios6.framework_version.should == '0.9.125'
      @device_iphone5_ios6.framework_version.should == '0.9.125'
      @device_ipad1_ios5.framework_version.should == '0.9.125'
      @device_ipod4_ios5.framework_version.should == '0.9.126'
    end
  end
end
