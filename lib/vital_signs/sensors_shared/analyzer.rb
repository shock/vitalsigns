module VitalSigns::SensorsShared::Analyzer
  ##########################################
  # Sensor Options
  def analyze(&block)
    raise "You must supply a block to the analyze option" if block.nil?
    raise "Analyzer block must accept sensor as a parameter." unless block.arity==1
    @analyzer=block; 
  end
  #
  ##########################################

  def analyze_output
    if @analyzer && @analyzer.call(self) && @health != VitalSigns::Sensors::HAPPY
      throw :done
    end
  end
  
end
