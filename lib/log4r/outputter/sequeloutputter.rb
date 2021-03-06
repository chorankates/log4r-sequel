require 'log4r'
require 'log4r/yamlconfigurator'
require 'sequel'
require 'yaml'

class SequelOutputter < Log4r::Outputter

  KNOWN_ENGINES = [
    :postgres,
    :sqlite,
  ]

  attr_reader :database, :delimiter, :engine, :file, :map, :table
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

    @engine = config[:engine].to_sym

    # error checking on table/column settings
    @table     = Time.now.strftime(config[:table]).to_sym
    @map       = config[:map]
    @delimiter = config[:delimiter]

    {
      :delimiter => @delimiter,
      :engine    => @engine,
      :formatter => config[:formatter], # feels a bit weird mixing instance variables and referencing the hash directly
      :map       => @map,
      :table     => @table,
    }.each_pair do |key, value|
      raise Log4r::ConfigError.new(sprintf('required key[%s] missing from configuration', key)) if value.nil?
    end

    if @engine.eql?(:postgres)
      @database = Time.now.strftime(config[:database])
      @file     = @table # this is technically the.. table, but maintaining interface cleanliness
      server    = config[:server]
      port      = config[:port]
      username  = config[:username]
      password  = config[:password]
      @dbh = Sequel.connect(sprintf('postgres://%s:%s@%s:%s/%s', username, password, server, port, @database))
    elsif @engine.eql?(:sqlite)
      @database = nil # sqlite has one DB per file
      @file = Time.now.strftime(config[:file])
      @dbh = Sequel.connect(sprintf('sqlite://%s', @file))
    else
      raise Log4r::ConfigError.new(sprintf('unable to use engine[%s], allowed[%s]', @engine, KNOWN_ENGINES))
    end

    @dbh
  end

  # +dbh+ a Sequel::Database handle
  ## while not really supported, if you take care of the database/table creation, you could hack it in here by <your_logger>.outputters[<sequel outputter>].connect(<dbh>)
  def connect(dbh)
    raise StandardError.new(sprintf('invalid parameter class[%s] expecting[Sequel::Database]', dbh.class)) unless dbh.is_a?(Sequel::Database)

    @dbh = dbh

    # idempotently create database/table
    initialize_db
  end

  def connected?
    # this is sufficient since we throw an exception during #connect if we don't get a good handle
    ! @dbh.nil?
  end

  private

  def write(data)
    raise StandardError.new(sprintf('%s is not connected, run %s.connect(yaml_file)', self.class, self.class)) unless connected?
    tokens = data.chomp.split(@delimiter)
    hash   = Hash.new

    tokens.each_with_index do |token, i|
      hash[@map[i].to_sym] = token
    end

    @dbh[@table].insert(hash)
  end

  def initialize_db
    map = @map # we're in a different class in the block below, can't access
    # TODO would be better to check to see if the DB is good rather than just throw an exception here
    @dbh.create_table? @table do
      primary_key :id
      map.values.each do |v|
        String v.to_sym
      end
    end
  end

end
