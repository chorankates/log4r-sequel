require 'log4r'
require 'log4r/yamlconfigurator'
require 'sequel'
require 'yaml'

# TODO  should we move this to ../logger.rb
class Log4r::Logger
  # +method+ String or Symbol representing the name of the method in the Log4r::Outputter::SequelOutputter class you want to use
  # +parameters+ arbitrary data type to be passed to :methods
  def sequel(method, parameters)
    # TODO support methods that take more than one parameter
    self.outputters.each do |op|
      next unless op.is_a?(SequelOutputter)
      return op.send(method.to_sym, parameters)
    end
  end
end

class SequelOutputter < Log4r::Outputter

  KNOWN_TYPES = [
    :postgres,
    :sqlite,
  ]

  YAML_KEY = 'log4r_sequel_config'

  attr_reader :database, :delimiter, :file, :map, :table, :type
  attr_accessor :dbh

  def initialize(name, hash)
    super(name, hash) # make us a real Log4r::Outputter object
    dbh = configure(hash) # validate settings passed
    connect(dbh) # actually connect to the DBH
  end

  # +input+ Hash of configuration options
  def configure(input)
    config = input

    # convert all keys to symbols
    new_config = Hash.new
    config.keys.each do |key|
      new_config[key.to_sym] = config[key]
    end
    config = new_config

    @type = config[:type]

    # error checking on table/column settings
    @table = config[:table].to_sym
    raise Log4r::ConfigError.new("required 'table' key missing from configuration") if @table.nil?

    @map = config[:map]
    raise Log4r::ConfigError.new("required 'map' key missing from configuration") if @map.nil?

    @delimiter = config[:delimiter]
    raise Log4r::ConfigError.new("required 'delimiter' key missing from configuration") if @delimiter.nil?

    if @type.eql?(:postgres)
      @database = config[:database]
      @file     = nil
      server    = config[:server]
      port      = config[:port]
      username  = config[:username]
      password  = config[:password]
      @dbh = Sequel.connect(sprintf('postgres://%s:%s@%s:%s/%s', username, password, server, port, @database))
    elsif @type.eql?(:sqlite)
      @database = nil # sqlite has one DB per file
      @file = config[:file]
      @dbh = Sequel.connect(sprintf('sqlite://%s', @file))
    else
      raise Log4r::ConfigError.new(sprintf('unable to use type[%s], allowed[%s]', @type, KNOWN_TYPES))
    end

    @dbh
  end

  # +dbh+ a Sequel::Database handle
  def connect(dbh)
    raise StandardError.new(sprintf('invalid parameter class[%s] expecting[Sequel::Database]', dbh.class)) unless dbh.is_a?(Sequel::Database)

    @dbh = dbh

    # idempotently create table/columns
    initialize_db
  end

  def connected?
    # this is sufficient since we throw an exception during #connect if we don't get a good handle
    ! @dbh.nil?
  end

  private

  def write(data)
    raise StandardError.new(sprintf('%s is not connected, run %s.connect(yaml_file)', self.class, self.class)) unless connected?
     # INSERT INTO `logs`(`id`,`date`,`level`,`class`,`message`) VALUES (1,NULL,NULL,NULL,NULL);
    tokens = data.split(@delimiter)
    hash = Hash.new

    tokens.each_with_index do |token, i|
      hash[@map[i].to_sym] = token
    end

    @dbh[@table].insert(hash)
  end

  def initialize_db
    map = @map # we're in a different class in the block below, can't access
    @dbh.create_table? @table do
      primary_key :id
      map.values.each do |v|
        String v.to_sym
      end
    end
  end

end
