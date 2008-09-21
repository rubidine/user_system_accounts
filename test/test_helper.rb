require File.join(File.dirname(__FILE__), '../../../../test/test_helper')
require 'rubygems'
require 'test/spec'

module FixtureReplacement
  @defaults_file = File.join(File.dirname(__FILE__), 'example_data.rb')
end
require 'fixture_replacement'

# Load more data stubs from user_system
require File.join(File.dirname(__FILE__), '../../user_system/test/example_data')

Test::Unit::TestCase.send :include, FixtureReplacement
