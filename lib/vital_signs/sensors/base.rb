class VitalSigns::Sensors::Base
  include VitalSigns::SensorsShared::CommonOptions
  
  attr_accessor :status, :health
  
  def initialize *args
    @status = "Not diagnosed."
    @health = VitalSigns::Sensors::UNDIAGNOSED
    @name=self.class.to_s
    @description = "No description"
    if block_given?
      config_block = Proc.new 
      raise "Configuration block must accept a sensor instance as a parameter." unless config_block.arity == 1
      config_block[self]
    end
  end
  
  def sense; raise NotImplementedError; end
end
