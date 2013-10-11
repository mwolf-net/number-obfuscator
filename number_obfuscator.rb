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

require './primes'

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
    #   a pair of integers.)

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

  # Call this function to get a new expression tree for the number
  # you specify!
  def Obfuscator.generate(n, depth = 4)
    Expression.makeExpression(n, depth)
  end

  # Use this helper method to create a full TeX document around a
  # formula.
  def Obfuscator.makeTeX(s)
    "\\documentclass{article}\n" + 
    "\\usepackage[pagewidth=\maxdimen,pageheight=\maxdimen]{geometry}" +
    "\\pagestyle{empty}\n"       + 
    "\\begin{document}\n"        + 
    "$$ #{s} $$\n"               + 
    "\\end{document}\n"
  end

  # Use this helper method to create a .png file for a given expression.
  def Obfuscator.makePNG(e, filename)
    require 'tempfile'
    tempfile = Tempfile.new('obfuscator').path

    File.open("#{tempfile}.tex", 'w') { |f|
      f.puts makeTeX(e.to_tex)
    }

    system("texi2dvi --build=clean --build-dir=#{tempfile}.t2d #{tempfile}.tex -o #{tempfile}.dvi")
    system("convert -format PNG -trim -density 200 #{tempfile}.dvi #{filename}")

    system("rm -rf #{tempfile}*")
  end

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

  # This class will generate an ordinary representation of n,
  # without further obfuscation. (TODO: generate non-decimal
  # numbers?)
  class Number < Expression
    def initialize(n)
      @n = n
    end

    def to_s
      @n.to_s
    end

    def to_tex
      to_s
    end

    def Number.canDo(n)
      true
    end

    def Number.make(n)
      Number.new(n)
    end
  end

  # The following classes all generate specific obfuscations
  # for the given number, which may include sub-expressions.
  #
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

  class Subtraction < BinaryExpression
    addType(Subtraction)

    def to_s
      "#{left.to_s}-(#{right.to_s})"
    end

    def to_tex
      r = right.to_tex
      r = "(#{r})" if Subtraction === right
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

  class SquareRoot < Expression
    addType(SquareRoot, 1)

    def initialize(square)
      @square = square
    end

    def to_s
      "Math.sqrt(#{@square.to_s})"
    end

    def to_tex
      "\\sqrt{#{@square.to_tex}}"
    end

    def SquareRoot.canDo(n)
      n > 1
    end

    def SquareRoot.make(n, depth)
      s = n * n
      SquareRoot.new(makeExpression(s, depth - 1))
    end
  end

end # module

if __FILE__ == $0

  if ARGV.size > 0
    n = ARGV[0]
    d = ARGV[1]
    d = 4 if d.to_i < 1
    e = Obfuscator.generate(n.to_i, d.to_i)
    if (ARGV[2] == 'png')
      Obfuscator.makePNG(e, 'obfuscated.png')
    elsif (ARGV[2] == 'tex')
      puts Obfuscator.makeTeX(e.to_tex)
    else
      puts e.to_s
    end
    exit
  end

  puts "Here are some sample obfuscations for the number 34:"
  for d in 2 .. 6
    puts Obfuscator.generate(34, d)
    puts
  end

  puts "And here is a small one in TeX format:"
  puts Obfuscator.generate(34, 4)
  puts
  
end

