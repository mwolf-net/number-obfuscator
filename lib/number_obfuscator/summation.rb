require_relative 'binary_expression'

module Obfuscator

  class Summation < BinaryExpression
    addType(Summation)

    def to_s
      "#{left.to_s}+#{right.to_s}"
    end

    def to_tex
      "#{left.to_tex}+#{right.to_tex}"
    end

    def Summation.canDo(n)
      n > 2
    end

    def Summation.makePair(n)
      l = rand(n - 1) + 1
      r = n - l
      [l, r]
    end
  end

end
