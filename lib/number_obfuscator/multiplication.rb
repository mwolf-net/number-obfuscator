require_relative 'binary_expression'

module Obfuscator

  class Multiplication < BinaryExpression
    addType(Multiplication, 1)

    def to_s
      "(#{left.to_s})*(#{right.to_s})"
    end

    def to_tex
      l = left.to_tex
      l = "(#{l})" if Summation === left || Subtraction === left
      r = right.to_tex
      r = "(#{r})" if Summation === right || Subtraction === right
      "#{l}\\cdot#{r}"
    end

    def Multiplication.canDo(n)
      n > 10 && ! Primes.isPrime?(n)
    end

    def Multiplication.makePair(n)
      f = Primes.factors(n)
      return [1, n] if f.empty?
      l = f[rand(f.size)]
      r = n / l
      [l, r]
    end
  end

end
