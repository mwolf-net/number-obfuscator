module Obfuscator
  # Forward declaration needed because Expression knows about Number (slight
  # violation of good OO practice here).
  class Expression; end
  class Number < Expression; end

  # Abstract base class for all the obfuscation expressions we can generate.
  #
  # Each subclass must, at class initialization time, register itself by calling
  # self.addType, otherwise it won't get used!
  #
  # In addition, all subclasses must implement the following:
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
  class Expression

    # Every expression subclass must register itself with the factory by calling
    # this method. "Weight" influences the likelyhood that a type will be
    # randomly chosen; a large weight means that expressions of that type will
    # show up more often in the output.
    @@types = []
    def self.addType(c, weight = 1)
      weight.times { @@types.push(c) }
    end

    # Each subclass of Expression must override to_s to return a valid
    # Ruby expression.
    def to_s
      raise "Subclass must override to_s!"
    end

    # Each subclass of Expression must override to_s to return a valid
    # TeX expression. 
    def to_tex
      raise "Subclass must override to_tex!"
    end

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
