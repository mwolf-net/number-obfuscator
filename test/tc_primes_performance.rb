#!/usr/bin/env ruby

require_relative "../lib/number_obfuscator/primes"
require "test/unit"

class TestPrimes < Test::Unit::TestCase

  def test_ten_million_primes
    Primes.generatePrimes(10_000_000) {
    }
  end

end

