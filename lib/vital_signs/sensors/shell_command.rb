class VitalSigns::Sensors::ShellCommand < VitalSigns::Sensors::Base
  include VitalSigns::SensorsShared::ShellCommands

  def initialize *args
    @require_exit_code_zero = true
    super
    @command = args.first
    raise "You must supply a command" unless @command
  end

private
  def build_command
    @command
  end
end
