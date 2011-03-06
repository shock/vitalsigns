module VitalSigns
  class Config
    attr_accessor :sensors
    class << self
      def parse_from_string config_string, filename="String", starting_line_number=1
        config = new
        config.instance_eval(config_string, filename, 1)
        config
      end
      
      def parse_from_file filename
        config_string = File.read(filename)
        parse_from_string config_string, filename, 1
      end
    end
    
    def initialize
      @sensors = {}
    end
    
  private  
    def method_missing(method, *args, &block)
      type = method
      sensor_class = get_sensor_class(type)
      sensor = sensor_class.new *args, &block
      @sensors[type] ||= []
      @sensors[type] << sensor
    end
    
    def get_sensor_class type
      sensor_classname = type.to_s.camelcase
      begin
        sensor_class = eval("VitalSigns::Sensors::#{sensor_classname}")
      rescue NameError
        raise "#{type} is not a valid sensor type."
      end
    end
  end
end
