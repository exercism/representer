module PrimeFactors
    extend self

    def factors(n : Int64)
        if n < 50000
            factors_reduced(n)
        else
            m = Math.sqrt(n).ceil.to_i64
            while n % m != 0
                m -= 1
            end
             
            if m == 1 # i.e. n is prime
                [n]
            else
                fs = factors(m) + factors(n // m)
                fs.sort
            end
        end
    end

    def factors_reduced(n : Int64)
        prime_factors = [] of Int64
        relevant_primes = sieve(n)
        prime_index = 0

        while n > 1
            if n % relevant_primes[prime_index] == 0
                prime_factors << relevant_primes[prime_index]
                n = n // relevant_primes[prime_index]
            else
                prime_index += 1
            end
        end

        prime_factors
    end

    # The machinery to get the list of relevant primes.
    private def filter_factors(arr, start, step)
        while start < arr.size
  	        arr[start] = false
  	        start += step
	    end
    end

    private def next_index(arr, curr)
	    curr = curr + 1
	    while curr < arr.size && !arr[curr]
		    curr += 1
	    end

	    curr
    end

    def sieve(n)
        primes =  [] of Int64

        if n >= 2
            ticks = Array(Bool).new(((n - 3) >> 1) + 1, true)
            curr_ind = 0

            while curr_ind < ticks.size
                start = 2*curr_ind*(curr_ind + 3) + 3 
                step = curr_ind + curr_ind + 3

                filter_factors(ticks, start, step)

                curr_ind = next_index(ticks, curr_ind)
            end

            primes << 2
            ticks.each_with_index do |b, i|
                if b
                    primes << (2*i + 3).to_i64
                end
            end
        end

        primes
    end
end
