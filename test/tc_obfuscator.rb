require 'test/unit'
require_relative '../number_obfuscator'

class TestNumberObfuscation < Test::Unit::TestCase

  # Due to rounding errors, re-evaluating a generated expression does not always
  # give exactly the original number back. But usually it's pretty close..
  ACCEPTABLE_ERROR = 0.00001

  def convert_tex_back_to_ruby(t)
    t.gsub!(/\\cdot/, '*')

    c = '\{([^\{\}]+)\}'
    begin 
      t1 = (nil == t.gsub!(/\\sqrt#{c}/, 'Math.sqrt(\1)'))
#      puts t
#      puts '---------'
      t2 = (nil == t.gsub!(/\\frac#{c}#{c}/, '(\1)/(\2)'))
#      puts t
#      puts '----'
    end until t1 && t2
    return t
  end

  def test_conversion_helper
    test  = '\frac{3 - 4 + 5 * 7 - 6}{4 + \sqrt{\sqrt{\frac{33 \cdot 7}{\sqrt{4}}}}}'
    orig  = '(3 - 4 + 5 * 7 - 6)/(4 + Math.sqrt(Math.sqrt((33 * 7) / (Math.sqrt(4)))))'
    test2 = convert_tex_back_to_ruby(test)
    assert_equal(eval(orig), eval(test2), test2)
  end

  def test_ruby_validity
    8.times { |d|
      20.times {
        n  = rand(100) + 1
        e  = Obfuscator.generate(n, d)
        s  = e.to_s
        v  = eval(s)
        t  = e.to_tex
        st = convert_tex_back_to_ruby(t)
        vt = eval(st)
        assert((v  - n).abs < ACCEPTABLE_ERROR, "Validating Ruby expression: #{s} == #{v}  == #{n}")
        assert((vt - n).abs < ACCEPTABLE_ERROR, "Validating TeX expression: #{st} == #{vt} == #{n}")
      }
    }
  end

  def test_0
    5.times { |d|
      5.times {
        e = Obfuscator.generate(0, d)
        assert_equal(0, eval(e.to_s))
      }
    }
  end

  def test_ordinary_number
    e = Obfuscator::Number.new(42)
    assert_equal("42", e.to_s)
    assert_equal("42", e.to_tex)
  end

  def test_png_creation
    tempfile = Tempfile.new('obfuscator_unittest').path + '.png'
    e = Obfuscator.generate(38, 4)
    Obfuscator.makePNG(e, tempfile)
    assert(File.exists?(tempfile))
  end

end
        
