require_relative 'binary_expression'

module Obfuscator

  class Subtraction < BinaryExpression
    addType(Subtraction)

    def to_s
      "#{left.to_s}-(#{right.to_s})"
    end

    def to_tex
      r = right.to_tex
      r = "(#{r})" if Summation === right || Subtraction === right
      "#{left.to_tex}-#{r}"
    end

    def Subtraction.canDo(n)
      n > 0
    end

    def Subtraction.makePair(n)
      l = n + rand(2*n) + 3
      r = l - n
      [l, r]
    end
  end

end
