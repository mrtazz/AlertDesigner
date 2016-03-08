require 'AlertDesigner/formatters'

require 'erb'
require 'ostruct'

module AlertDesigner
  module Formatters
    class Nagios < Formatter

      class NagiosDefinition < OpenStruct

        TEMPLATE = <<-EOS
define <%= type %>{
<% properties.each do |key, value| %>
    <%= key %>    <%= value %>
<% end %>
}

        EOS

        def render
          ERB.new(TEMPLATE, 0, '<>').result(binding)
        end

      end

      def check_template(template)
        @check_template = template
      end

      def format(type, value)
        return format_checks(value) if type == :checks
        return nil
      end

	private

      def format_checks(checks)
        ret = ""
        checks.each do |check|
          # split up host groups with default and explicitly specified contact
          # definitions
          hgroups, hgroups_with_contacts = check.hostgroups.partition do |grp|
            grp.kind_of?(String)
          end

          # create service definition for default contacts
          fmt_check = NagiosDefinition.new
          fmt_check.type = "service"
          fmt_check.properties = check.attributes
          fmt_check.properties["use"] = @check_template
          fmt_check.properties["service_description"] = check.description
          fmt_check.properties["check_command"] = check.command
          fmt_check.properties["hostgroup_name"] = hgroups.join(",")
          ret << fmt_check.render

          # create service definition for specified contacts
          hgroups_with_contacts.each do |entry|
            entry.each do |group, contact|
              fmt_check = NagiosDefinition.new
              fmt_check.type = "service"
              fmt_check.properties = check.attributes
              fmt_check.properties["use"] = @check_template
              fmt_check.properties["service_description"] = check.description
              fmt_check.properties["check_command"] = check.command
              fmt_check.properties["hostgroup_name"] = group
              fmt_check.properties["contact_groups"] = contact
              ret << fmt_check.render
            end
          end

        end

        ret
      end

    end
  end
end
