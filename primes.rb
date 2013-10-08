# This module provides the class Primes, which maintains an array of
# precomputed prime numbers and offers some methods to use them for purposes
# such as factorization. It does not pretend to offer the World's Fastest
# Factorizer, or even the World's Fastest Factorizer Written In Ruby, but
# because of the precomputed prime numbers it should be fairly efficient.
#
# When using this class from within a mod_ruby application, the precomputation
# should be done only once per process.
#
# Written by Martin Wolf, http://mwolf.net. This code is in the public domain.

module Primes

  # MAX_PRIME controls the array of pre-computed primes to be used.  During
  # factorization, any number greater than MAX_PRIME will be treated as a prime
  # number, meaning it won't be factorized further.
  MAX_PRIME = 50000

  # MAX_BYTES controls the largest number we'll attempt to factorize.
  MAX_BYTES = 30

  # Returns an array containing all prime numbers less than or equal to n.
  def Primes.generatePrimes(n)
    sieve = Array.new(n+1)
    for i in 2...n
      yield i if not sieve[i]
      i.step(n, i) { |x| sieve[x] = true }
    end
  end

  # Generate all primes up to MAX_PRIME, to help factoring largish numbers
  @@primes = []
  generatePrimes(MAX_PRIME) { |p| @@primes.push(p) }

  # Returns an array containing all the factors of n, not counting the trivial
  # factors 1 and n. By default, factors are not duplicated, so e.g. the result
  # for n == 20 will be [2, 5]. If n is not a positive integer, the result will
  # be empty. If n cannot be factorized, the result will be [n]. The result will
  # never contain 0 or 1. Note: if n (or any of the intermediate results of its
  # factorization) is not divisible by any prime number smaller than MAX_PRIME,
  # we give up. So if you were planning to use this function to crack RSA keys,
  # you're out of luck.  :-)
  def Primes.factors(n, uniqueOnly = true)
    return [] if ! n.integer?
    return [] if n.size > MAX_BYTES
    fs = []
    for i in @@primes
      break if i > n
      if n % i == 0
        fs.push i
        n /= i
        redo if !uniqueOnly
      end
    end
    fs
  end

  # Determines whether n has any factors less than max_prime; if not then it is
  # prime as far as we are concerned.
  def Primes.isPrime?(n)
    return false if ! n.integer?
    return false if n.size > MAX_BYTES
    @@primes.each { |i|
      return true if n == i
      return false if n % i == 0
    }
    return true
  end

end # class Primes

if __FILE__ == $0
  puts "With uniqueonly: %s" % Primes.factors(7000).join(' ')
  puts "Without uniqueonly: %s" % Primes.factors(7000, false).join(' ')
  puts "Factoring a prime number: %s" % Primes.factors(19).join(' ')
  puts "Factoring 1: %s" % Primes.factors(1).join(' ')
  puts "Factoring a large but easy number: %s" %
  Primes.factors(133333333333333333333333333333333).join(' ')
  puts "Is 19 a prime? %s" % Primes.isPrime?(19)
  puts "Is 20 a prime? %s" % Primes.isPrime?(20)
end


