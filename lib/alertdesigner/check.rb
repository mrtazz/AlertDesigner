module AlertDesigner
  # Class to represent a check
  class Check < BasicObject
    def initialize(description)
      @attributes = {}
      @description = description
      @command = ""
      @hostgroups = []
    end

    def command(command = nil)
      return @command if command.nil?
      @command = command
    end

    def hostgroups(groups = nil)
      return @hostgroups if groups.nil?
      @hostgroups = groups
    end

    attr_reader :attributes, :description

    def method_missing(name, *args)
      attributes[name] = args[0]
    end
  end
end
