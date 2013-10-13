require_relative 'expression'

module Obfuscator

  class SquareRoot < Expression
    addType(SquareRoot, 1)

    def initialize(square)
      @square = square
    end

    def to_s
      "Math.sqrt(#{@square.to_s})"
    end

    def to_tex
      "\\sqrt{#{@square.to_tex}}"
    end

    def SquareRoot.canDo(n)
      n > 1
    end

    def SquareRoot.make(n, depth)
      s = n * n
      SquareRoot.new(makeExpression(s, depth - 1))
    end
  end

end
