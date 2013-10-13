require_relative 'expression'

module Obfuscator
  class BinaryExpression < Expression
    attr :left
    attr :right

    public
    def initialize(l, r)
      @left  = l
      @right = r
    end

    def self.make(n, depth)
      (l, r) = makePair(n)
      self.new(makeExpression(l, depth - 1),
               makeExpression(r, depth - 1))
    end
  end
end

