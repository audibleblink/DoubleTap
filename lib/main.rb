require 'optparse'

# RUby like to be smart about wheh it flushes STDOUT. Don't let it.
$stdout.sync = true

options = {}
OptionParser.new do |parser|

  parser.on("-m", "--module MODULE", "The MODULE you wish to execute") do |opt|
    options[:module] = opt
  end

  parser.on("-v", "--verbose", "Displays attemps in addition to successes") do |opt|
    options[:verbose] = true
  end

end.parse!

raise "You must specify a module" unless options[:module]
VERBOSE = options[:verbose]
require_relative "../modules/#{options[:module]}"
