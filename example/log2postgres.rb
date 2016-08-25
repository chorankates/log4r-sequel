$LOAD_PATH << sprintf('%s/../lib', File.dirname(__FILE__))

#require 'log4r-sequel'
require 'log4r/outputter/sequel'

file = sprintf('%s/log4r-postgres.yaml', File.dirname(__FILE__))
Log4r::YamlConfigurator.load_yaml_file(file)

logger  = Log4r::Logger.get('bar')
logger2 = Log4r::Logger.get('bar')

# these must be run before actually using the logger
# TODO we also need to handle the case where our user/database don't exist
dbh = logger.sequel(:configure, file)
logger.sequel(:connect, dbh)

dbh2 = logger2.sequel(:configure, {
  :type   => :postgres,
  :server => 'localhost',
  :port   => 5432,
  :username => 'postgres',
  :password => 'postgres',
  :database => 'logs',
  :table    => 'logs', # TODO come up with some way to sanely differentiate between these twi
  :delimiter => '!@#$',
  # TODO let's use a different pattern here
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