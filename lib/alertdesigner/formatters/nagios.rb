require "alertdesigner/formatters"

require "erb"
require "ostruct"

module AlertDesigner
  module Formatters
    # Class for the generic nagios formatter
    class Nagios < Formatter
      # Generic Nagios definition class
      class NagiosDefinition < OpenStruct
        TEMPLATE = <<-EOS.freeze
define <%= type %>{
<% properties.each do |key, value| %>
    <%= key %>    <%= value %>
<% end %>
}

        EOS

        def render
          ERB.new(TEMPLATE, 0, "<>").result(binding)
        end

        def self.get_service(check, check_template)
          fmt_check = NagiosDefinition.new
          fmt_check.type = "service"
          fmt_check.properties = check.attributes
          fmt_check.properties["use"] = check_template
          fmt_check.properties["service_description"] = check.description
          fmt_check.properties["check_command"] = check.command
          fmt_check
        end

        def self.get_command(name, cmd)
          fmt_command = NagiosDefinition.new
          fmt_command.type = "command"
          fmt_command.properties = {}
          fmt_command.properties["command_name"] = name
          fmt_command.properties["command_line"] = cmd
          fmt_command
        end
      end

      def check_template(template)
        @check_template = template
      end

      def format(type, value)
        return format_checks(value) if type == :checks
        return format_commands(value) if type == :commands
      end

      private

      def format_commands(commands)
        ret = ""

        commands ||= []

        commands.each do |cmd|
          command = NagiosDefinition.get_command(cmd.name, cmd.command)
          ret << command.render
        end

        ret
      end

      def format_checks(checks)
        ret = ""
        checks.each do |check|
          # split up host groups with default and explicitly specified contact
          # definitions
          hgroups, hgroups_with_contacts = check.hostgroups.partition do |grp|
            grp.is_a?(String)
          end

          # create service definition for default contacts
          fmt_check = NagiosDefinition.get_service(check, @check_template)
          fmt_check.properties["hostgroup_name"] = hgroups.join(",")
          ret << fmt_check.render

          ret << checks_for_hostgroups_with_contacts(check,
                                                     hgroups_with_contacts)
        end

        ret
      end

      def checks_for_hostgroups_with_contacts(check, hgroups)
        ret = ""
        # create service definition for specified contacts
        hgroups.each do |entry|
          entry.each do |group, contact|
            fmt_check = NagiosDefinition.get_service(check, @check_template)
            fmt_check.properties["hostgroup_name"] = group
            fmt_check.properties["contact_groups"] = contact
            ret << fmt_check.render
          end
        end

        ret
      end
    end
  end
end
