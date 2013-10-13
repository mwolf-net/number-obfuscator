require_relative 'number'

module Obfuscator

  class Expression

    # Every expression subclass must register itself with the factory by calling
    # this method. "Weight" influences the likelyhood that a type will be
    # randomly chosen; a large weight means that expressions of that type will
    # show up more often in the output.
    @@types = []
    def self.addType(c, weight = 1)
      weight.times { @@types.push(c) }
    end

    # All subclasses must implement the following:
    # * to_s: render the expression in Ruby format
    # * to_tex: render the expression in TeX format
    # * Class method canDo(n): determines whether it is possible
    #   to create an object of this type with the value n. For
    #   example, a Summation can only produce numbers greater
    #   than 1.
    # * Class method make(n, depth): returns a randomly-generated
    #   expression object of the given type, with the value n.
    #   (Note that BinaryExpression implements this method for
    #   all its subclasses; they implement makePair, which returns
    #   a pair of integers which together satisfy the equation.)

    def self.makeExpression(n, depth)
      if (depth <= 0)
        Number.new(n)
      else
        expr = nil
        attempts = 1
        while expr.nil? && attempts < 10
          type = @@types[rand(@@types.size)]
          expr = type.canDo(n) ? type.make(n, depth) : nil
          attempts += 1
        end
        expr || Number.new(n) # Safety guard for hard-to obfuscate numbers..
      end
    end
  end

end
