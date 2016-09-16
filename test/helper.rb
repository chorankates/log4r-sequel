#!/usr/bin/env ruby
## helper.rb sets up pathing and common requires for tests

$LOAD_PATH << sprintf('%s/../lib', File.dirname(__FILE__))
require 'log4r/outputter/sequeloutputter'

require 'test/unit'

class Log4r::Logger

  # no parameters, returns the first SequelOutputter object
  def get_outputter
    self.outputters.each do |op|
      next unless op.is_a?(SequelOutputter)
      return op
    end
  end

end