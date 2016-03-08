require File.expand_path('../../test_helper', __FILE__)

require 'test/unit'
require 'alertdesigner/formatters/nagios'
require 'alertdesigner/check'

class FormatterNagiosTest < Test::Unit::TestCase

  def setup
    @formatter = AlertDesigner::Formatters::Nagios.new
    @formatter.check_template "generic-service"
  end

  def teardown
  end

  def test_split_hostgroups_by_contact
		c = AlertDesigner::Check.new "simple check"
    c.command "check_nrpe!check_root"
    c.hostgroups ["Webservers"]

    ret = @formatter.format(:checks, [c])

    expected = <<-EOS
define service{
    use    generic-service
    service_description    simple check
    check_command    check_nrpe!check_root
    hostgroup_name    Webservers
}

    EOS

    assert_equal(expected, ret)

  end
end
