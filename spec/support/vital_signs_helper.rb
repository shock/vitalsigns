log_filename = File.join(File.dirname(__FILE__),'..','..','log',"#{ENV["RAILS_ENV"]}.log")

if defined?(LOG_TO_STDOUT) && LOG_TO_STDOUT
  logger = Logger.new(STDOUT)
else
  logger = Logger.new(File.open(log_filename,'a'))
end

if defined? Rails
  Rails.logger = logger
end
