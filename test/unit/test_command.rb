require File.expand_path('../../test_helper', __FILE__)

require 'test/unit'
require 'alertdesigner/command'

class CommandTest < Test::Unit::TestCase

  def setup
    @c = AlertDesigner::Command.new "check-host-alive"
  end

  def teardown
  end

  def test_basic_instantiation
    @c.command "$USER1$/check_ping -H $HOSTADDRESS$ -w 3000.0,80% -c 5000.0,100% -p 5"
    assert_equal("check-host-alive", @c.name)
    assert_equal("$USER1$/check_ping -H $HOSTADDRESS$ -w 3000.0,80% -c 5000.0,100% -p 5", @c.command)
  end
end
