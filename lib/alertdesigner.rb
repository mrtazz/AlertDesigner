require 'alertdesigner/formatters'
require 'alertdesigner/check'

module AlertDesigner

  @checks = []
  @formatters = []

  def self.checks
    @checks
  end

  def self.formatters
    @formatters
  end

  def self.define(&block)
    instance_eval(&block)
  end

  def self.check(description, &block)
    check = Check.new(description)
    check.instance_eval(&block)
    @checks << check
  end

  def self.formatter(formatter_class, &block)
    formatter = formatter_class.new
    formatter.instance_eval(&block)
    @formatters << formatter
  end

  def self.format
    ret = ""
    @formatters.each do |formatter|
      ret << formatter.format(:checks, @checks)
    end
    ret
  end

end
