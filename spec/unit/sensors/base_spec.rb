require 'spec_helper'

describe VitalSigns::Sensors::Base do
  
  before(:all) do
    @config_class = VitalSigns::Config
    @base_class = VitalSigns::Sensors::Base
  end
  
  before(:each) do
  end
  
  after(:each) do
  end
  
  context "Default attributes" do
    before(:each) do
      @base = @base_class.new
    end
    
    it "should have an initial health of UNDIAGNOSED" do
      @base.health.should == VitalSigns::Sensors::UNDIAGNOSED
    end
    it "should have an initial status of UNDIAGNOSED" do
      @base.status.should == "Not diagnosed."
    end
  end

  context "Configuration Options" do
    it "accepts a name configuration option" do
      config_string=<<-CFG
        base do |sensor|
          sensor.name= 'name'
        end
      CFG
      config=@config_class.parse_from_string(config_string)
      config.sensors[:base].first.name.should == 'name'
    end

    it "accepts a description configuration option" do
      config_string=<<-CFG
        base do |sensor|
          sensor.description= 'description'
        end
      CFG
      config=@config_class.parse_from_string(config_string)
      config.sensors[:base].first.description.should == 'description'
    end

  end

end
