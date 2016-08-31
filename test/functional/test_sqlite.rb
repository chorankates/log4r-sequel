$LOAD_PATH << sprintf('%s/../../lib', File.dirname(__FILE__))
require 'log4r/outputter/sequeloutputter'

require 'test/unit'

class TestSqlite < Test::Unit::TestCase

  def setup
    @good_config = sprintf('%s/../log4r-sqlite_test.yaml', File.expand_path(File.dirname(__FILE__)))
    @table = :logs

    begin
      require 'sqlite3'
    rescue LoadError
      omit('sqlite3 not installed/configured')
    end
  end

  def teardown
    # TODO remove the database.. assume it's just '*.sqlite' in this path?
  end


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

  def test_sad_config
    # TODO pass in bad configs as hashes
  end


end