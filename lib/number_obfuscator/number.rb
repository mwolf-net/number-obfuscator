module Obfuscator

  # forward declaration
  class Expression
  end

  # This class will generate an ordinary representation of n, without further
  # obfuscation. (TODO: generate non-decimal numbers?)
  class Number < Expression
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

    def Number.make(n)
      Number.new(n)
    end
  end
end
