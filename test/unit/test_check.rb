require File.expand_path('../../test_helper', __FILE__)

require 'test/unit'
require 'alertdesigner/check'

class CheckTest < Test::Unit::TestCase

  def setup
    @c = AlertDesigner::Check.new "simple check"
  end

  def teardown
  end

  def test_basic_instantiation
    @c.command "check_nrpe!check_root"
    @c.hostgroups ["Webservers"]
    assert_equal("simple check", @c.description)
    assert_equal("check_nrpe!check_root", @c.command)
    assert_equal(["Webservers"], @c.hostgroups)
  end

  def test_method_missing
    @c.foo "foo"
    assert_equal("foo", @c.attributes[:foo])
  end
end
