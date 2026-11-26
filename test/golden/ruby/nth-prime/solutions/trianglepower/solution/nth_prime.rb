module Prime
  def self.nth(n)
    raise ArgumentError.new if n <= 0
    
    a = 32
    primes = []

    until primes.length >= n
      primes.concat(getprimes(a).slice(primes.length..))
      a *= 2

      puts "#{primes.length} -> #{a}"
    end

    return primes[n-1]
  end

  def self.getprimes(count)
    done = Set.new
    primes = Set.new
    
    (2..count).each do |i|
      primes.add(i) unless done.include?(i)
      
      j = i
      while j <= count
        done.add(j)
        j += i
      end
    end

    return primes.to_a
  end
end
