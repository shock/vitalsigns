require 'spec_helper'

describe VitalSigns::Sensors::ShellCommand do
  
  before(:all) do
    @config_class = VitalSigns::Config
  end
  
  before(:each) do
  end
  
  after(:each) do
  end
  
  context "Configuration" do
    it "requires a command", :focus=>false do
      config_string=<<-CFG
        shell_command 'command'
      CFG
      lambda{@config_class.parse_from_string(config_string)}.should_not raise_error
      config_string=<<-CFG
        shell_command
      CFG
      lambda{@config_class.parse_from_string(config_string)}.should raise_error
    end
    
  end

  context "Execution" do
    before(:each) do
      @config_string=<<-CFG
        shell_command 'command'
      CFG
      @sensor=@config_class.parse_from_string(@config_string).sensors[:shell_command].first
    end
    
    it "builds the command string properly", :focus=>false do
      @sensor.send(:build_command).should == 'command'
    end
    
    it "sets the health to DEAD if the command returns non-zero exit code and require_exit_code_zero is set to true", :focus=>false do
      @sensor.should_receive(:execute_command).exactly(1).times.and_return do 
        @sensor.instance_eval do
          @command_output = 'Hello.'
          @exit_code = 1
        end
      end
      @sensor.require_exit_code_zero.should == true
      @sensor.sense
      @sensor.health.should == VitalSigns::Sensors::DEAD
    end

    it "sets the health to HAPPY if the command returns zero exit code and require_exit_code_zero is set to true", :focus=>false do
      @sensor.should_receive(:execute_command).exactly(1).times.and_return do 
        @sensor.instance_eval do
          @command_output = 'Hello.'
          @exit_code = 0
        end
      end
      @sensor.require_exit_code_zero.should == true
      @sensor.sense
      @sensor.health.should == VitalSigns::Sensors::HAPPY
    end

    it "ignores the exit code if require_exit_code_zero is set to false", :focus=>false do
      @sensor.require_exit_code_zero = false
      @sensor.should_receive(:execute_command).exactly(1).times.and_return do 
        @sensor.instance_eval do
          @command_output = 'Hello.'
          @exit_code = 1
        end
      end
      @sensor.sense
      @sensor.health.should == VitalSigns::Sensors::HAPPY
    end

    it "sends the command output to the analyze block when configured", :focus=>false do
      @sensor.analyze do |sensor|
        if sensor.command_output == 'Hello.'
          sensor.status = "analyzed"
          sensor.health = 3
        end
      end
      @sensor.should_receive(:execute_command).exactly(1).times.and_return do 
        @sensor.instance_eval do
          @command_output = 'Hello.'
          @exit_code = 0
        end
      end
      @sensor.sense
      @sensor.status.should == "analyzed"
      @sensor.health.should == 3
    end
  end
  
  describe "integration" do
    before(:each) do
      @config_string=<<-CFG
        shell_command "ls #{File.dirname(__FILE__)}" do |sensor|
          sensor.analyze do |s|
            if s.command_output !=~ /shell_common_spec.rb/
              s.health = VitalSigns::Sensors::DEAD
              s.status = "Poisonous shell_common_spec.rb file detected!"
            end
          end
        end
      CFG
      @sensor=@config_class.parse_from_string(@config_string).sensors[:shell_command].first
    end
    
    it "works" do
      @sensor.sense
      @sensor.status.should == "Poisonous shell_common_spec.rb file detected!"
      @sensor.health.should == VitalSigns::Sensors::DEAD
    end
  end
  
end
