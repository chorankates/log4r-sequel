$LOAD_PATH << sprintf('%s/../', File.dirname(__FILE__))

require 'helper'

class TestPostgres < Test::Unit::TestCase

  def setup
    # TODO move this to a helper class - or a function that returns one based on .. criteria
    @good_config = sprintf('%s/../config/log4r-postgres.yaml', File.expand_path(File.dirname(__FILE__)))
    @table = Time.now.strftime('logs-%Y/%m/%d-%H:%M').to_sym

    begin
      require 'pg'
    rescue LoadError
      omit('[pg] not installed/configured')
    end

  end

  def teardown; end

  def test_happy_yaml
    file = @good_config
    Log4r::YamlConfigurator.load_yaml_file(file)

    logger = nil

    assert_nothing_raised do
      logger  = Log4r::Logger.get('test')
    end

    assert_not_nil(logger)
    assert_equal(0, logger.get_outputter.dbh[@table].count)

    assert_nothing_raised do
      logger.debug('this is a debug message')
      logger.info('this is an info message')
      logger.warn('this is a warning')
      logger.error('this is an error')
      logger.fatal('this is a fatal')
    end

    assert_not_equal(0, logger.get_outputter.dbh[@table].count)

  end

  def test_happy_hash
    logger = nil

    assert_nothing_raised do
      #logger = Logger::Log4r.new()
      p 'DBGZ' if nil?
    end

    #assert_equal(0, logger.get_outputter.dbh[@table].count)

  end

end