require 'spec_helper'

describe VitalSigns::Sensors::SshCommand do
  
  before(:all) do
    @config_class = VitalSigns::Config
  end
  
  before(:each) do
  end
  
  after(:each) do
  end
  
  context "Configuration" do
    it "requires host and command", :focus=>false do
      config_string=<<-CFG
        ssh_command 'host', 'command'
      CFG
      lambda{@config_class.parse_from_string(config_string)}.should_not raise_error
      config_string=<<-CFG
        ssh_command
      CFG
      lambda{@config_class.parse_from_string(config_string)}.should raise_error
    end
    
    it "accepts a user configuration option" do
      config_string=<<-CFG
        ssh_command 'host', 'command' do |sensor|
          sensor.user= 'user'
        end
      CFG
      config=@config_class.parse_from_string(config_string)
      config.sensors[:ssh_command].first.user.should == 'user'
    end
    
    it "accepts a bin configuration option" do
      config_string=<<-CFG
        ssh_command 'host', 'command' do |sensor|
          sensor.bin= 'bin'
        end
      CFG
      config=@config_class.parse_from_string(config_string)
      config.sensors[:ssh_command].first.bin.should == 'bin'
    end
    
    it "accepts a port configuration option" do
      config_string=<<-CFG
        ssh_command 'host', 'command' do |sensor|
          sensor.port= 'port'
        end
      CFG
      config=@config_class.parse_from_string(config_string)
      config.sensors[:ssh_command].first.port.should == 'port'
    end
    
    it "bin defaults to 'ssh'" do
      config_string="ssh_command 'host', 'command'"
      config=@config_class.parse_from_string(config_string)
      config.sensors[:ssh_command].first.bin.should == 'ssh'
    end
    
    it "port default to 22" do
      config_string="ssh_command 'host', 'command'"
      config=@config_class.parse_from_string(config_string)
      config.sensors[:ssh_command].first.port.should == 22
    end
    
  end

  context "Execution" do
    before(:each) do
      @config_string=<<-CFG
        ssh_command 'host', 'command' do |sensor|
          sensor.user = 'user'
          sensor.port = 22000
          sensor.bin = '/usr/bin/ssh'
        end
      CFG
      @sensor=@config_class.parse_from_string(@config_string).sensors[:ssh_command].first
    end
    
    it "builds the command string properly", :focus=>false do
      @sensor.send(:build_command).should == '/usr/bin/ssh -p 22000 user@host command'
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
        ssh_command 'ba1', 'ls' do |sensor|
          sensor.analyze do |s|
            if s.command_output !=~ /install/
              s.health = VitalSigns::Sensors::DEAD
              s.status = "Poisonous install directory detected!"
            end
          end
        end
      CFG
      @sensor=@config_class.parse_from_string(@config_string).sensors[:ssh_command].first
    end
    
    it "works" do
      @sensor.sense
      @sensor.status.should == "Poisonous install directory detected!"
      @sensor.health.should == VitalSigns::Sensors::DEAD
    end
  end
  
end
