module VitalSigns::SensorsShared::ShellCommands
  attr_reader :exit_code, :command_output
  
  ##########################################
  # Sensor Options
  attr_accessor :require_exit_code_zero
  #
  ##########################################
  
  def self.included(base)
    base.send(:include, VitalSigns::SensorsShared::Analyzer)
  end

  ##########################################
  # Analysis Helpers
  def test_exit_code
    if @require_exit_code_zero && @exit_code != 0
      @status = "Failed.  Expected exit code 0.  Got #{@exit_code}"
      @health = VitalSigns::Sensors::DEAD
      throw :done
    end
  end
  #
  ##########################################
  
  ##########################################
  # Execution Helpers
  def execute_command
    @command_output = `#{build_command}`
    @exit_code = $?.exitstatus
  end
  
  def sense
    @health = VitalSigns::Sensors::HAPPY # be optimistic! HAPPY unless diagnosed otherwise
    @status = "Alive and Happy."
    catch(:done) do
      execute_command
      test_exit_code
      analyze_output
    end
  end
  #
  ##########################################
  
end
