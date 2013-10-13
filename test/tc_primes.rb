#!/usr/bin/ruby
require "primes"
require "test/unit"

class TestPrimes < Test::Unit::TestCase

  # Check that a is an array containing all prime numbers below one million.
  def checkArray1M(a)
    assert_equal(a.size, 78498)  # Checked with Wolfram Alpha
    assert_equal(2, a[0])
    assert_equal(3, a[1])
    assert_equal(999983, a[-1])  # Checked with Wolfram Alpha
  end

  def test_max_prime
    # Several of the other tests depend on this, so..
    assert_equal(999983, Primes.largestKnownPrime)
  end

  def test_number_of_primes
    a = []
    Primes.generatePrimes(1_000_000) { |p|
      a.push(p)
    }
    checkArray1M(a)
  end

  def test_allprimes_with_block
    a = []
    Primes.all { |p|
      a.push(p)
    }
    checkArray1M(a)
  end

  def test_allprimes_without_block
    checkArray1M(Primes.all)
  end

  Euler3_input    = 600851475143
  Euler3_solution = [71, 839, 1471, 6857]

  def test_unique_factors
    a = Primes.factors(Euler3_input)
    assert_equal(Euler3_solution, a)
  end

  def test_unique_factors_2
    a = Primes.factors(1_000)
    assert_equal([2, 5], a)
  end

  def test_duplicated_factors
    a = Primes.factors(1_000, false)
    assert_equal([2, 2, 2, 5, 5, 5], a)
  end

  def test_factoring_a_prime
    assert_equal([839], Primes.factors(839, false))
    assert_equal([839], Primes.factors(839, true))
  end

  def test_factoring_edgecases
    assert_equal([], Primes.factors(1, false))
    assert_equal([], Primes.factors(1, true))
    assert_equal([], Primes.factors(0, false))
    assert_equal([], Primes.factors(0, true))
    assert_equal([], Primes.factors(-3, false))
    assert_equal([], Primes.factors(-3, true))
    assert_equal([], Primes.factors(33.2, false))
    assert_equal([], Primes.factors(33.2, true))
  end

  def test_too_large_to_factor
    # Tests that when the input has a prime factor greater than one million, we
    # just return that factor as if it were a prime number. This is a bit of a
    # dubious test since the answer is actually incorrect! The correct answer
    # would be [7, 47, 179, 12713, 281081, 216273151, 2929595521]
    n = 133333333333333333333333333333333
    e = [7, 47, 179, 12713, 281081, 633592854482156671]
    assert_equal(e, Primes.factors(n))
  end

  def test_primes
    [2, 3, 5, 7, 11, 13, 839, 999983, 8492569, 1_000_003].each { |p|
      assert(Primes.isPrime?(p), "#{p} is supposed to be prime")
    }
  end

  def test_nonprimes
    # Note that we are quite capable of determining if a number above
    # Primes.MAX_PRIME is prime; we only get into trouble when none of its
    # prime factors is below MAX_PRIME..
    [-5, -1, 0, 1, 4, 6, 8, 100, 1_000_000, 1_000_005, Euler3_input,
      1000_000_000_000_000, 999983 ** 3].each { |n|
      assert(! Primes.isPrime?(n), "#{n} is not supposed to be prime")
    }
  end
end

