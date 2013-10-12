require 'test/unit'
require 'mocha/setup'
require_relative '../number_obfuscator'

class C
  def C.f x
    return 44 * x
  end
end

class TestExpressionsWithMocks < Test::Unit::TestCase

  def test_stub_rand
    # Need to stub 'self', not 'Kernel'!
    self.stubs(:rand).with(99).returns(3)
    assert_equal(3, rand(99))
  end

  def test_sqrt
    Obfuscator::SquareRoot.
      expects(:makeExpression).
      with(100, 0).
      returns(Obfuscator::Number.new(100))
    sr = Obfuscator::SquareRoot.make(10, 1)
    assert_equal("Math.sqrt(100)", sr.to_s)
  end

  def test_summation
    Obfuscator::Summation.
      expects(:rand).
      with(99).
      returns(39)
    Obfuscator::Summation.
      expects(:makeExpression).
      with(40, 0).
      returns(Obfuscator::Number.new(40))
    Obfuscator::Summation.
      expects(:makeExpression).
      with(60, 0).
      returns(Obfuscator::Number.new(60))
    sr = Obfuscator::Summation.make(100, 1)
    assert_equal("40+60", sr.to_s)
    assert_equal("40+60", sr.to_tex)
  end
end


