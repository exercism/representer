# BookKeeping
module BookKeeping
  VERSION = 1
end

# Sieve
class Sieve
  def initialize(n)
    @range = (2..n).to_a
  end

  def primes
    @prime ||= []
    while @range.count >= 0
      p = @range.shift
      @prime << p
      @range.reject! { |i| (i % p).zero? }
    end
    @prime
  end
end