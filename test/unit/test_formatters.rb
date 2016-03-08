require File.expand_path('../../test_helper', __FILE__)

require 'test/unit'
require 'alertdesigner/formatters'

class FormatterTest < Test::Unit::TestCase

  def setup
  end

  def teardown
  end

  def test_formatter_is_abstract
    format = AlertDesigner::Formatters::Formatter.new
    assert_raise RuntimeError do
      format.format("foo", "bar")
    end
  end
end
