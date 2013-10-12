#!/usr/bin/ruby

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
  # factorization, any number which is not divisible by any of these primes,
  # will be treated as a prime number.
  MAX_PRIME = 1_000_000

  # MAX_BYTES controls the largest number we'll attempt to factorize.
  MAX_BYTES = 30

  # Yields all prime numbers less than or equal to n.
  # This is intended as an internal method, used only for initializing the
  # array of precomputed primes, but you can call it separately if you want.
  def Primes.generatePrimes(n)
    # Implementation notes: we use the Sieve of Eratosthenes. 'sieve' starts
    # out as an array of booleans set to false; at the end of the algorithm,
    # all the composite numbers will have been set to true, so the 'false'
    # values remaining are the primes.

    # To avoid wasting space on the even numbers, we treat 2 as a special
    # case.
    sieve = Array.new(n / 2 + 1, false)
    yield 2

    # No need to sieve out numbers greater than the square root of the
    # largest number we're looking for, since all of them will have
    # been sieved out by a smaller number already.
    sqrt_n = Math.sqrt(n).truncate
    sqrt_n += 1 if sqrt_n % 2 == 0 # Make sure it's odd
    3.step(sqrt_n, 2) do |i|
      if not sieve[i / 2]
        # Found a new prime number!
        yield i
        # All multiples of this number, must be composites. Any number
        # below i squared, will have been set to true on a previous round
        # already. And of course we can skip the even multiples of i.
        (i * i).step(n, i * 2) { |x| sieve[x / 2] = true }
      end
    end

    # All composites above sqrt(n) have been sieved out at this point,
    # so we just need to yield the remaining primes.
    (sqrt_n + 2).step(n, 2) { |i| yield i if not sieve[i / 2] }
  end

  # Generate all primes up to MAX_PRIME, to help factoring largish numbers
  @@primes = []
  generatePrimes(MAX_PRIME) { |p| @@primes.push(p) }
  @@primes.freeze

  def Primes.all
    return @@primes if not block_given?
    @@primes.each { |p| yield p }
  end

  def Primes.largestKnownPrime
    return @@primes[-1]
  end

  # Returns an array containing all the factors of n, not counting the trivial
  # factors 1 and n. By default, factors are not duplicated, so e.g. the result
  # for n == 20 will be [2, 5]. If n is not a positive integer, the result will
  # be empty. If n cannot be factorized, the result will be [n]. The result will
  # never contain 0 or 1. Note: if n (or any of the intermediate results of its
  # factorization) is not divisible by any prime number smaller than MAX_PRIME,
  # we give up. So if you were planning to use this function to crack RSA keys,
  # you're out of luck.  :-)
  def Primes.factors(n, uniqueOnly = true)
    return [] if ! n.kind_of?(Integer)
    return [] if n < 2
    return [] if n.size > MAX_BYTES
    fs = []
    sqrt_n = Math.sqrt(n).truncate
    for i in @@primes
      break if i > sqrt_n
      if n % i == 0
        n /= i
        fs.push i
        while n % i == 0
          n /= i
          fs.push i if !uniqueOnly
        end 
      end
    end
    fs.push(n) if n > 1
    fs
  end

  # Check if n is a member of our collection of pre-computed primes, using
  # a binary search. This is called implicitly by isPrime? when
  # n < MAX_PRIME, so there's normally no reason to call it separately.
  def Primes.isInPrimes?(n, pos1 = 0, pos2 = @@primes.size - 1)
    # Implementation is recursive; more elegant but slightly slower.
    return true if @@primes[pos1] == n
    return true if @@primes[pos2] == n
    return false if pos2 - pos1 <= 1
    midpos = (pos1 + pos2) / 2
    return isInPrimes?(n, midpos, pos2 - 1) if n >= @@primes[midpos]
    return isInPrimes?(n, pos1 + 1, midpos)
  end
  
  # Determines whether n has any factors less than max_prime; if not then it is
  # prime as far as we are concerned.
  def Primes.isPrime?(n)
    return false if ! n.kind_of?(Integer)
    return false if n < 2
    return isInPrimes?(n) if n < MAX_PRIME
    return false if n.size > MAX_BYTES
    sqrt_n = Math.sqrt(n).truncate
    @@primes.each { |i|
      break if i > sqrt_n
      return false if n % i == 0
    }
    return true
  end

end # class Primes

# Hidden feature: when this module file is executed directly:
#   * With command-line arguments: factor them
#   * Without command-line arguments: print primes until aborted (performance
#     drops sharply after reaching MAX_PRIME).
if __FILE__ == $0
  if ARGV.size > 0
    for n in ARGV
      puts "#{n.to_i} = #{Primes.factors(n.to_i, true).join(' * ')}"
    end
  else
    for p in Primes.all
      puts p
    end
    n = Primes.largestKnownPrime + 2
    while true
      puts n if Primes.isPrime?(n)
      n += 2
    end
  end
end


