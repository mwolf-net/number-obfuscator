module Obfuscator

  # Use this helper method to create a full TeX document around a
  # formula.
  def Obfuscator.makeTeX(s)
    tex = (Expression === s) ? s.to_tex : s.to_s
    "\\documentclass{minimal}\n" + 
    "\\usepackage[paperwidth=100cm,paperheight=100cm]{geometry}" +
    "\\pagestyle{empty}\n"       + 
    "\\begin{document}\n"        + 
    "$$ #{tex} $$\n"             + 
    "\\end{document}\n"
  end

end
