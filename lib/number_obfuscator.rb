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
require_relative 'number_obfuscator/primes'
require_relative 'number_obfuscator/expression'
require_relative 'number_obfuscator/summation'
require_relative 'number_obfuscator/subtraction'
require_relative 'number_obfuscator/multiplication'
require_relative 'number_obfuscator/division'
require_relative 'number_obfuscator/square_root'

module Obfuscator

  # Call this function to get a new expression tree for the number
  # you specify!
  def Obfuscator.generate(n, depth = 4)
    Expression.makeExpression(n, depth)
  end

  # Use this helper method to create a full TeX document around a
  # formula.
  def Obfuscator.makeTeX(s)
    "\\documentclass{minimal}\n" + 
    "\\usepackage[paperwidth=100cm,paperheight=100cm]{geometry}" +
    "\\pagestyle{empty}\n"       + 
    "\\begin{document}\n"        + 
    "$$ #{s} $$\n"               + 
    "\\end{document}\n"
  end

  # Use this helper method to create a .png file for a given expression.
  def Obfuscator.makePNG(e, filename)
    tempfile = Tempfile.new('obfuscator').path

    File.open("#{tempfile}.tex", 'w') { |f|
      f.puts makeTeX(e.to_tex)
    }

    texcall = "texi2dvi --build=clean --build-dir=#{tempfile}.t2d #{tempfile}.tex -o #{tempfile}.dvi > /dev/null"
    pngcall = "dvipng -D 300 -T tight -o #{filename} #{tempfile}.dvi"

    # TODO: redirecting to /dev/null probably breaks Windows..
    if ! system(texcall, :out => '/dev/null' )
      raise "texi2dvi failed. Is it (and a TeX installation such as texlive) installed?"
    end

    if ! system(pngcall, :out => '/dev/null')
      raise "dvipng failed. Is it installed?"
    end

    system("rm -rf #{tempfile}*")
  end

end # module
