require_relative './../spec_helper'

module Briar
  SIM__IPHONE_5__IOS_6_JSON = "{\"outcome\":\"SUCCESS\",\"app_name\":\"Rise Up CAL\",\"simulator_device\":\"iPhone\",\"iOS_version\":\"6.0\",\"app_version\":\"1.0\",\"system\":\"x86_64\", \"app_id\":\"org.recoverywarrriors.RiseUp-cal\",\"version\":\"0.9.126\", \"simulator\":\"iPhone Simulator 358.4, iPhone OS 6.0 (iPhone (Retina 4-inch)\/10A403)\"}"
  DEVICE__IPHONE_4__IOS_6_JSON = "{\"outcome\":\"SUCCESS\",\"app_name\":\"Rise Up CAL\",\"iOS_version\":\"6.0.1\",\"app_version\":\"1.0\",\"system\":\"iPhone4,1\",\"app_id\":\"org.recoverywarrriors.RiseUp-cal\",\"version\":\"0.9.125\"}"
  DEVICE__IPHONE_5__IOS_6_JSON = "{\"outcome\":\"SUCCESS\",\"app_name\":\"Rise Up CAL\",\"iOS_version\":\"6.0.1\",\"app_version\":\"1.0\",\"system\":\"iPhone5,0\",\"app_id\":\"org.recoverywarrriors.RiseUp-cal\",\"version\":\"0.9.125\"}"
  DEVICE__IPAD1__IOS_5_JSON = "{\"outcome\":\"SUCCESS\",\"app_name\":\"Rise Up CAL\",\"iOS_version\":\"5.1.1\",\"app_version\":\"1.0\",\"system\":\"iPad1,1\",\"app_id\":\"org.recoverywarrriors.RiseUp-cal\",\"version\":\"0.9.125\"}"

  describe "Gestalt" do
    before(:each) do
      @sim_iphone_5_ios6 = Gestalt.new(SIM__IPHONE_5__IOS_6_JSON)
      @device_iphone4_ios6 = Gestalt.new(DEVICE__IPHONE_4__IOS_6_JSON)
      @device_iphone5_ios6 = Gestalt.new(DEVICE__IPHONE_5__IOS_6_JSON)
      @device_ipad1_ios5 = Gestalt.new(DEVICE__IPAD1__IOS_5_JSON)
    end

    it "should be able to determine ios major version" do
      @sim_iphone_5_ios6.is_ios6?.should == true
      @sim_iphone_5_ios6.is_ios5?.should == false

      @device_iphone4_ios6.is_ios6?.should == true
      @device_iphone4_ios6.is_ios5?.should == false

      @device_ipad1_ios5.is_ios6?.should == false
      @device_ipad1_ios5.is_ios5?.should == true
    end


    it "should be able to determine if running on device or simulator" do
      @sim_iphone_5_ios6.is_simulator?.should == true
      @sim_iphone_5_ios6.is_device?.should == false

      @device_iphone4_ios6.is_simulator?.should == false
      @device_iphone4_ios6.is_device?.should == true

      @device_ipad1_ios5.is_simulator?.should == false
      @device_ipad1_ios5.is_device?.should == true

    end


    it "should be able to determine the device family" do
      @sim_iphone_5_ios6.is_iphone?.should == true
      @sim_iphone_5_ios6.is_ipad?.should == false

      @device_iphone4_ios6.is_iphone?.should == true
      @device_iphone4_ios6.is_ipad?.should == false

      @device_ipad1_ios5.is_iphone?.should == false
      @device_ipad1_ios5.is_ipad?.should == true

    end

    it "should be able to determine the if the runtime is on iphone 5" do
      @sim_iphone_5_ios6.is_iphone_5?.should == true
      @device_iphone4_ios6.is_iphone_5?.should == false
      @device_iphone5_ios6.is_iphone_5?.should == true
      @device_ipad1_ios5.is_iphone_5?.should == false
    end
  end
end
