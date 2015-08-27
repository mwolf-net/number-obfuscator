module Obfuscator
  class Expression; end # Needed because {Expression} knows about {Number}.
  class Number < Expression; end

  # @abstract Base class for all the obfuscation expressions we can generate.
  #
  # Each subclass must, at class initialization time, register itself by calling
  # self.addType, otherwise it won't get used! Also, all subclasses must
  # implement {#to_s} and {#to_tex} and the class method {Expression.make}.
  class Expression

    @@types = []

    # Every expression subclass must register itself with the factory by calling
    #   this method.
    #
    # "Weight" influences the likelyhood that a type will be
    # randomly chosen; a large weight means that expressions of that type will
    # show up more often in the output.
    def self.addType(c, weight = 1)
      weight.times { @@types.push(c) }
    end

    # @abstract Each subclass of Expression must override to_s to return a valid
    #   Ruby expression, which can be parsed with 'eval' to get the original
    #   number back.
    def to_s
      raise "Subclass must override to_s!"
    end

    # @abstract Each subclass of Expression must override to_s to return a valid
    #   TeX expression, such as '3\\cdot9'.
    def to_tex
      raise "Subclass must override to_tex!"
    end

    # @abstract Override this to create a new sub-expression.
    #
    # Each subclass of Expression must provide a class-level 'make' method which
    # returns an object of that subclass, representing n.
    #
    # In order to create its own sub-expressions, it calls 'make' again with a
    # depth value of "depth - 1". (Subclasses do not need to worry about the
    # case that depth == 0; {Expression.makeExpression} will take care of that.)
    #
    # Subclass implementations are allowed to return 'nil' if they are unable to
    # provide an expression for the given n.
    #
    # @param n [Integer] The number to obfuscate.
    # @param depth [Integer] Desired depth of the expression. Will be >= 1.
    # @return [Expression, nil] New Expression, or nil if not possible to create
    #   one.
    def Expression.make(n, depth)
      raise "Subclass must provide its own 'make'!"
    end

    # (see Obfuscator.generate)
    def Expression.makeExpression(n, depth)
      if (depth <= 0)
        Number.new(n)
      else
        expr = nil
        attempts = 1
        while expr.nil? && attempts < 10
          candidates = @@types.select { |t| t.canDo(n) }
		  type = candidates[rand(candidates.size)]
          expr = type.make(n, depth)
          attempts += 1
        end
        expr || Number.new(n) # Safety guard for hard-to obfuscate numbers..
      end
    end
  end

end
