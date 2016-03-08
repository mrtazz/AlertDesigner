# AlertDesigner

[![Build Status](https://travis-ci.org/mrtazz/AlertDesigner.svg?branch=master)](https://travis-ci.org/mrtazz/AlertDesigner)
[![Coverage Status](https://coveralls.io/repos/mrtazz/AlertDesigner/badge.svg?branch=master&service=github)](https://coveralls.io/github/mrtazz/AlertDesigner?branch=master)
[![MIT license](https://img.shields.io/badge/license-MIT-blue.svg)](http://opensource.org/licenses/MIT)

## Overview
AlertDesigner is a Ruby DSL to create Nagios checks. It attempts to take some
of the repetitive work of creating Nagios alerts away. It's supposed to
complement your existing setup and not necessarily replace it.

## Example

```ruby
AlertDesigner.define do

  # let's use the Nagios formatter
  formatter NagiosFormatter do
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
    "FreeBSD kernel version"   => "check_nrpe!check_freebsd_kernel",
    "zpool status"             => "check_nrpe!check_zpool"
  }.each do |description, check_cmd|

    check description do
      hostgroups ["freebsd-base"]
      command check_cmd
    end

  end

  # set contact groups for specific clusters
  check "Apache Running" do
    hostgroups ["WebServers" => "web-team", "ApiServers" => "api-team"]
    command  "check_nrpe!check_httpd"
  end

end

puts AlertDesigner.format
```

## FAQ
### Couldn't most of this be done with a clever config hierarchy?
Probably.


## Inspiration
- [Gmail Britta](https://github.com/antifuchs/gmail-britta)
- [Chef](https://www.chef.io/)

