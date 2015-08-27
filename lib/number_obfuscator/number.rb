require_relative 'expression'

module Obfuscator

  # This class will generate an ordinary representation of n, without further
  # obfuscation. (TODO: generate non-decimal numbers?)
  class Number < Expression
    addType(Number, 1)

    def initialize(n)
      @n = n
    end

    def to_s
      @n.to_s
    end

    def to_tex
      to_s
    end

    def Number.canDo(n)
      true
    end

    def Number.make(n, _)
      Number.new(n)
    end
  end
end
