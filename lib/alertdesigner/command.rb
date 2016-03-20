module AlertDesigner
  # Class to represent a command
  class Command < BasicObject
    attr_reader :command, :name

    def initialize(name)
      @name = name
      @command = ""
    end

    def command(command = nil)
      return @command if command.nil?
      @command = command
    end
  end
end
