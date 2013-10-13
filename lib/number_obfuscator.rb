# This Ruby module generates complex-looking equations for natural numbers. For
# example, the number 34 might get expressed as sqrt(15876/21+589-189). And
# that's a simple example! The output can be in either Ruby-compatible format
# or in TeX format.
#
# When run in stand-alone mode with at least one argument, prints an obfuscation
# for that number on standard output. Optional second argument is the expression
# depth (use 3 for reasonably human-readable, 4 to 6 for nicely complex, 8 for
# ridiculous). Optional third argument is 'tex' for output in TeX format, or
# 'png' to create a file named obfuscated.png.
#
# When run in stand-alone mode without arguments, prints some test strings.
#
# Written by Martin Wolf, martin@mwolf.net. Free to copy and use as long as
# my name is kept in the source.

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

module Obfuscator

  # Call this method to get a new expression tree for the number
  # you specify!
  def Obfuscator.generate(n, depth = 4)
    Expression.makeExpression(n, depth)
  end

end # module
