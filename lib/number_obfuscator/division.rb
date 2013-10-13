require_relative 'binary_expression'

module Obfuscator

  class Division < BinaryExpression
    addType(Division, 3)

    def to_s
      "(#{left.to_s})/(#{right.to_s})"
    end

    def to_tex
      "\\frac{#{left.to_tex}}{#{right.to_tex}}"
    end

    def Division.canDo(n)
      n > 1
    end

    def Division.makePair(n)
      r = rand(300) + 70
      l = r * n
      [l, r]
    end
  end

end

