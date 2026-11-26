module Primes

  def self.sieve(n : Int32) : Array(Int32)
    nums = (2..n).to_a
    primes = [] of Int32

    until nums.empty?
      p = nums[0]
      primes << p
      (p..n).step(by: p) { |i| nums.delete(i) }
    end

    return primes
  end
end
