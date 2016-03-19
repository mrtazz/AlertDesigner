module AlertDesigner
  module Formatters
    # basic (abstract) class to inherit from for formatters
    class Formatter
      def format(_type, _value)
        raise "'format' method not implemented."
      end
    end
  end
end
