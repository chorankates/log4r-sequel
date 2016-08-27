$LOAD_PATH << sprintf('%s/../lib', File.dirname(__FILE__))

#require 'log4r-sequel'
require 'log4r/outputter/sequeloutputter'

file = sprintf('%s/log4r-postgres.yaml', File.dirname(__FILE__))
Log4r::YamlConfigurator.load_yaml_file(file)

logger  = Log4r::Logger.get('bar')

[logger].each do |l|
  ## log some garbage
  l.debug('this is a debug message')
  l.info('this is an info message')
  l.warn('this is a warning')
  l.error('this is an error')
  l.fatal('this is a fatal')
end