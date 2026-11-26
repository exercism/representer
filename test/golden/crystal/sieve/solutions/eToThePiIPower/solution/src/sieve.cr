class Primes
  def self.sieve(n : Int32) : Array(Int32)
    primes = [] of Int32
    return primes if n < 2

    ints = (2..n).to_a

    until ints.empty?
      primes << ints[0]
      ints.reject!(&.divisible_by?(primes.last))
    end

    primes
  end
end
