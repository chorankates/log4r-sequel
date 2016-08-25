$LOAD_PATH << sprintf('%s/../lib', File.dirname(__FILE__))

require 'sqlite3'

#require 'log4r-sequel'
require 'log4r/outputter/sequel'

## instantiate a logger following the log4r pattern
file = sprintf('%s/log4r-sqlite.yaml', File.dirname(__FILE__))
Log4r::YamlConfigurator.load_yaml_file(file)

logger  = Log4r::Logger.get('foo')
logger2 = Log4r::Logger.get('foo')
# these must be run before using the logger
dbh = logger.sequel(:configure, file)
logger.sequel(:connect, dbh)

dbh2 = logger2.sequel(:configure, {
  :type => :sqlite,
  :file => 'log2.sqlite',
  :table => 'logs',
  :delimiter => '!@#$',
  :map => {
    0 => 'date',
    1 => 'level',
    2 => 'class',
    3 => 'message',
  },
})

logger2.sequel(:connect, dbh2)

[logger, logger2].each do |l|
  ## log some garbage
  l.debug('this is a debug message')
  l.info('this is an info message')
  l.warn('this is a warning')
  l.error('this is an error')
  l.fatal('this is a fatal')
end
