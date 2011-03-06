require 'spec_helper'

describe VitalSigns::Config do

  include ConfigHelper
  
  before(:all) do
    @config_class = VitalSigns::Config
    class VitalSigns::Sensors::TestSensor < VitalSigns::Sensors::Base
    end
    @test_sensor_class = VitalSigns::Sensors::TestSensor
  end
  
  before(:each) do
  end
  
  after(:each) do
  end
  
  context "Parsing a String" do
    it "parses an empty string", :focus=>false do
      lambda{@config_class.parse_from_string("")}.should_not raise_error
    end

    it "parses valid sensor line with no arguments", :focus=>false do
      config = @config_class.parse_from_string("test_sensor")
      config.sensors[:test_sensor].length.should == 1
    end
    
    it "passes arguments to the sesnor's constructor", :focus=>false do
      @test_sensor_class.should_receive(:new).with("argument").exactly(1).times
      config = @config_class.parse_from_string("test_sensor 'argument'")
      config.sensors[:test_sensor].length.should == 1
    end

    it "evaluates sensor's config block in the context of its instance", :focus=>false do
      class Receiver
        def self.signal
        end
      end
      Receiver.should_receive(:signal).exactly(1).times
      class VitalSigns::Sensors::TestSensor < VitalSigns::Sensors::Base
        def option argument
          Receiver.signal if argument == 'option_argument'
        end
      end
      config = @config_class.parse_from_string("test_sensor {|sensor| sensor.option 'option_argument'}")
      config.sensors[:test_sensor].length.should == 1
    end
  end

end
