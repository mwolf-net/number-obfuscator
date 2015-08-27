module Obfuscator

  # Use this helper method to create a .png file for a given expression.
  def Obfuscator.makePNG(e, filename)
    tempfile = Tempfile.new('obfuscator').path

    File.open("#{tempfile}.tex", 'w') { |f|
      f.puts makeTeX(e.to_tex)
    }

    texcall = "texi2dvi --build=clean --build-dir=#{tempfile}.t2d #{tempfile}.tex -o #{tempfile}.dvi"
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

end
