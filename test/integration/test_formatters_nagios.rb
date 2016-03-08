require File.expand_path('../../test_helper', __FILE__)

require 'test/unit'
require 'alertdesigner'
require 'alertdesigner/formatters/nagios'

class FormatterNagiosTest < Test::Unit::TestCase

  def setup
  end

  def teardown
  end

  def test_nagios_formatter_integration

    AlertDesigner.define do

      # let's use the Nagios formatter
      formatter AlertDesigner::Formatters::Nagios do
        check_template "generic-service"
      end

      # a simple disk space check
      check "/ Partition Disk Space" do
        hostgroups ["freebsd-base"]
        command  "check_nrpe!check_root"
      end

      # define some base checks with repeating properties
      {
        "vulnerable packages"      => "check_nrpe!check_portaudit",
        "FreeBSD security updates" => "check_nrpe!check_freebsd_update",
      }.each do |description, check_cmd|

        check description do
          hostgroups ["freebsd-base"]
          command check_cmd
        end

      end

      # set contact groups for specific clusters
      check "Apache Running" do
        hostgroups ["LinuxServers", "WebServers" => "web-team", "ApiServers" => "api-team"]
        command  "check_nrpe!check_httpd"
      end

    end

    ret = AlertDesigner.format

    expected = <<-EOS
define service{
    use    generic-service
    service_description    / Partition Disk Space
    check_command    check_nrpe!check_root
    hostgroup_name    freebsd-base
}

define service{
    use    generic-service
    service_description    vulnerable packages
    check_command    check_nrpe!check_portaudit
    hostgroup_name    freebsd-base
}

define service{
    use    generic-service
    service_description    FreeBSD security updates
    check_command    check_nrpe!check_freebsd_update
    hostgroup_name    freebsd-base
}

define service{
    use    generic-service
    service_description    Apache Running
    check_command    check_nrpe!check_httpd
    hostgroup_name    LinuxServers
}

define service{
    use    generic-service
    service_description    Apache Running
    check_command    check_nrpe!check_httpd
    hostgroup_name    WebServers
    contact_groups    web-team
}

define service{
    use    generic-service
    service_description    Apache Running
    check_command    check_nrpe!check_httpd
    hostgroup_name    ApiServers
    contact_groups    api-team
}

EOS

    assert_equal(expected, ret)
  end

end
