class Sieve
  def initialize(n)
    @n = n
  end

  def primes
    sieve = [nil, nil, *2..@n]

    (2..Math.sqrt(@n)).each do |i|
      (i**2..@n).step(i) { |m| sieve[m] = nil }  if sieve[i]
    end

    sieve.compact
  end
end