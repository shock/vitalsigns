module VitalSigns
  # namespace our plugin and inherit from Rails::Railtie
  # to get our plugin into the initialization process
  class Engine < Rails::Engine
    
    # config.autoload_paths << SOME_LOAD_PATH
    
    # initialize our plugin on boot. 
    initializer "vital_signs.initialize" do |app|
    end
    
    config.after_initialize do
    end

  end
end
