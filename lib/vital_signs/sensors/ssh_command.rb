class VitalSigns::Sensors::SshCommand < VitalSigns::Sensors::Base
  include VitalSigns::SensorsShared::ShellCommands
  
  ##########################################
  # Sensor Options
  attr_accessor :user, :bin, :port
  #
  ##########################################
  
  def initialize *args
    @bin = "ssh"
    @port = 22
    @require_exit_code_zero = true
    super
    @host, @command = *args
    raise "You must supply a host" unless @host
    raise "You must supply a command" unless @command
  end
  
private
  def build_command
    host_string = if @user
      "#{@user}@#{@host}"
    else
      @host
    end
    "#{@bin} -p #{@port} #{host_string} #{@command}"
  end
end
