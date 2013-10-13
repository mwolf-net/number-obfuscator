require 'tempfile'

['primes', 'expression', 'tex', 'png'].each { |rb|
  require_relative "number_obfuscator/#{rb}"
}

# Get the expression types we want to support. Each needs to register itself by
# calling Expression.addType, otherwise it won't get used!
[ 'number', 'summation', 'subtraction', 'multiplication',
  'division', 'square_root'].each { |rb|
  require_relative "number_obfuscator/#{rb}"
}

# The namespace module which all number_obfuscator stuff goes into.
#
# Helper methods {Obfuscator.makePNG} and {Obfuscator.makeTeX} are in separate files.
module Obfuscator

  # Returns a new, randomly generated expression tree for a given number.
  #
  # @param n [Integer]     The number to be obfuscated.
  # @param depth [Integer] Desired depth (complexity) of the expression.
  # @return [Expression]   An {Expression} representing n.
  def Obfuscator.generate(n, depth = 4)
    Expression.makeExpression(n, depth)
  end

end # module
