#!/opt/bin/julia

function prime_factors(num::Integer)
    #Our base condition:
    if num==1
        return []
    end
    
    #Search for primes, leaning heavily on the memoization for efficiency.
    for i in 2:num
        # print("Factoring $num: Trying $i.")

        if num %i ==0
            # print("  Found a divisor! :)\n")
            return sort(vcat([i], prime_factors(num÷i)))
        end
        # print("\n")
    end

    @assert false "Should not get here."
end