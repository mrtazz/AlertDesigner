if ENV["COVERAGE"]
  require 'coveralls'
  require 'simplecov'
  SimpleCov.start do
    add_group "lib"
    add_filter "/test/"
    command_name "Unit Tests"
  end
end

require 'test/unit'

module TestHelper
end
