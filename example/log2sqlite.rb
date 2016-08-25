$LOAD_PATH << sprintf('%s/../lib', File.dirname(__FILE__))

require 'sqlite3'

#require 'log4r-sequel'
require 'log4r/outputter/sequel'

## instantiate a logger following the log4r pattern
file    = sprintf('%s/log4r-sqlite.yaml', File.dirname(__FILE__))
_config = Log4r::YamlConfigurator.load_yaml_file(file)
logger  = Log4r::Logger.get('foo')
#logger.connect(config) # this must be run before using the logger - TODO should we override Log4r::Logger#get to accept this as an arg to initialize?
logger.outputters.first.connect(file) # TODO come up with a better way to run this..

## log some garbage
logger.debug('this is a debug message')
logger.info('this is an info message')
logger.warn('this is a warning')
logger.error('this is an error')
logger.fatal('this is a fatal')