$LOAD_PATH << sprintf('%s/../', File.dirname(__FILE__))

require 'helper'

class TestSqliteUnit < Test::Unit::TestCase

  def setup
    # TODO should this be a constant?
    @good_config     = File.expand_path(sprintf('%s/../config/log4r-sqlite.yaml', File.dirname(__FILE__)))
    @good_loggername = :test.to_s
    @table           = :logs

    begin
      require 'sqlite3'
    rescue LoadError
      omit('[sqlite3] not installed/configured') # TODO this really needs to omit the entire test
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
      logger = Log4r::Logger.get(@good_loggername)
    end

    assert_not_nil(logger)
  end

  def test_sad_yaml
    good_yaml = YAML.load_file(@good_config)
    sad_yamls = Hash.new

    # delete vital keys here and create an array of sad yamls, but cheating a little to find our config
    fail(sprintf('invalid input to generate sad yaml[%s]', good_yaml)) unless good_yaml.has_key?('log4r_config') and
      good_yaml['log4r_config'].has_key?('outputters') and
      good_yaml['log4r_config']['outputters'].last['type'].eql?('SequelOutputter')

    {
      :formatter.to_s => Hash.new.class,
      :map.to_s       => Hash.new.class,

      :delimiter.to_s => String.new.class,
      :engine.to_s    => String.new.class,
      :table.to_s     => String.new.class,
    }.each_pair do |key, _klass|
      candidate = Marshal.load(Marshal.dump(good_yaml))
      candidate['log4r_config']['outputters'].last.delete(key)
      sad_yamls[key] = candidate
    end

    sad_yamls.each_pair do |name, config|

      logger = nil

      e = assert_raises Log4r::ConfigError do
        Log4r::YamlConfigurator.load_yaml_string(config.to_yaml) # it's valid YAML, just missing required options
        logger = Log4r::Logger.get(@good_loggername)
      end

      assert_match(Regexp.new(sprintf('[%s]', name)), e.message)
      assert_nil(logger)

    end

  end

  def test_happy_hash
    logger = Log4r::Logger.new(@good_loggername)

    table = 'logs%y%m%d'
    fmt_table = Time.now.strftime(table)

    hash = {
      :type => 'SequelOutputter',
      :name => 'sequel',
      :formatter => Log4r::Formatter.new({
        :type         => 'PatternFormatter',
        :date_pattern => '%Y/%m/%d %H:%M.%s',
        :pattern      => '%d!@#$%C!@#$%l!@#$%m',
      }),

      :engine => 'sqlite',
      :file => 'log-%y-%m-%d-%H-%M.sqlite',
      :table => table, # use the non-strftimed format here
      :delimiter => '!@#$',
      :map => {
        0 => 'date',
        1 => 'level',
        2 => 'class',
        3 => 'message',
      },
    }

    assert_nothing_raised do
      outputter = Log4r::Outputter::SequelOutputter.new(
        'sequel',
        hash,
      )
      logger.add(outputter)
    end

    assert_equal(0, logger.get_outputter.dbh[fmt_table].count)
    assert_not_equal(hash[:file], logger.get_outputter.file)
    assert_not_equal(hash[:table], logger.get_outputter.table)
  end

end