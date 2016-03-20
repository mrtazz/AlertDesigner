if ENV["COVERAGE"]
  require "coveralls"
  require "simplecov"
  SimpleCov.start do
    add_filter "/test/"
    command_name "Integration Tests"
  end
end


require 'test/unit'
require 'alertdesigner'
require 'alertdesigner/formatters/nagios'

class FormatterNagiosTest < Test::Unit::TestCase

  def setup
  end

  def teardown
    AlertDesigner.reset
  end

  def test_nagios_formatter_services

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

  def test_nagios_formatter_commands

    AlertDesigner.define do

      # let's use the Nagios formatter
      formatter AlertDesigner::Formatters::Nagios

      # define some basic commands
      {
        "check_nrpe"       => "$USER1$/check_nrpe2 -H $HOSTADDRESS$ -c $ARG1$ -t 30",
        "check_local_disk" => "$USER1$/check_disk -w $ARG1$ -c $ARG2$ -p $ARG3$",
      }.each do |name, check_cmd|

        command name do
          command check_cmd
        end

      end
    end

    ret = AlertDesigner.format

    expected = <<-EOS
define command{
    command_name    check_nrpe
    command_line    $USER1$/check_nrpe2 -H $HOSTADDRESS$ -c $ARG1$ -t 30
}

define command{
    command_name    check_local_disk
    command_line    $USER1$/check_disk -w $ARG1$ -c $ARG2$ -p $ARG3$
}

EOS

    assert_equal(expected, ret)
  end

end
