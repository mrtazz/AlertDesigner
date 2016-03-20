require "alertdesigner/formatters"
require "alertdesigner/check"
require "alertdesigner/command"

# Top level AlertDesigner module with static methods for the DSL
module AlertDesigner
  @checks = []
  @formatters = []
  @commands = []

  def self.checks
    @checks
  end

  def self.formatters
    @formatters
  end

  def self.commands
    @commands
  end

  def self.define(&block)
    instance_eval(&block)
  end

  def self.reset
    @checks = []
    @formatters = []
    @commands = []
  end

  def self.check(description, &block)
    check = Check.new(description)
    check.instance_eval(&block)
    @checks << check
  end

  def self.command(name, &block)
    command = Command.new(name)
    command.instance_eval(&block)
    @commands << command
  end

  def self.formatter(formatter_class, &block)
    formatter = formatter_class.new
    formatter.instance_eval(&block) if block_given?
    @formatters << formatter
  end

  def self.format
    ret = ""
    @formatters.each do |formatter|
      ret << formatter.format(:checks, @checks)
      ret << formatter.format(:commands, @commands)
    end
    ret
  end
end
