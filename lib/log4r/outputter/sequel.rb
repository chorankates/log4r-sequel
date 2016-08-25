require 'log4r'
require 'log4r/yamlconfigurator'
require 'sequel'
require 'yaml'

class SequelOutputter < Log4r::Outputter

  KNOWN_TYPES = [
    :postgres,
    :sqlite,
  ]

  attr_reader :database, :dbh, :delimiter, :file, :map, :table, :type

  def initialize(name, hash)
    super(name, hash) # make us a real Log4r::Outputter object
  end

  # +file+ YAML file containing a 'log4r_sequel_config' Hash
  # TODO support passing the Hash directly
  def connect(file)
    config = YAML.load_file(file)['log4r_sequel_config']

    # get a Sequel database handle
    @type = config[:type.to_s]

    if @type.eql?(:postgres)
      # TODO implement this
      p 'DBGZ' if nil?
    elsif @type.eql?(:sqlite)
      @database = nil # sqlite has one DB per file
      @file = config[:file.to_s]
      @dbh = Sequel.connect(sprintf('sqlite://%s', @file))
    else
      raise Log4r::ConfigError.new(sprintf('unable to use type[%s], allowed[%s]', @type, KNOWN_TYPES))
    end

    # error checking on table/column settings
    @table = config[:table.to_s].to_sym
    raise Log4r::ConfigError.new("required 'table' key missing from configuration") if @table.nil?

    @map = config[:map.to_s]
    raise Log4r::ConfigError.new("required 'map' key missing from configuration") if @map.nil?

    @delimiter = config[:delimiter.to_s]
    raise Log4r::ConfigError.new("required 'delimiter' key missing from configuration") if @delimiter.nil?

    # idempotently create table/columns
    initialize_db

    p 'DBGZ' if nil?
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