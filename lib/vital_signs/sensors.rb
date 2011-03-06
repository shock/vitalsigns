module VitalSigns
  module Sensors
    HAPPY=10
    SICK=5
    DEAD=0
    UNDIAGNOSED=-1
  end

  module SensorsShared
  end
end

Dir["#{File.dirname(__FILE__)}/sensors_shared/**/*.rb"].each { |f| require f }
Dir["#{File.dirname(__FILE__)}/sensors/**/*.rb"].each { |f| require f }

