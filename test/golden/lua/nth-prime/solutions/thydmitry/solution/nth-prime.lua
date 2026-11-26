return function(n)
        if n < 1 then n() end

        local primes = {2, 3, 5}
        local q = 3
        local q2 = q^2

        local p = 7
        local step = 4

        while #primes < n do
            while p > q2 do
                q = q + 1
                q2 = q^2
            end

            local i = 3

            while primes[i] <= q do
                if p % primes[i] == 0 then
                    -- Not a prime.
                    goto continue
                end

                i = i + 1
            end

            primes[#primes + 1] = p

            ::continue::
            p = p + step
            -- All primes above 2 and 3 fit the formula 6n±1 for natural n.
            -- That is why we switch between +2 and +4 to avoid those divisable by 3.
            step = step > 2 and 2 or 4
        end

        return primes[n]
end

    
--[[    
return function(n)
        if n < 1 then
            n(10)
        end
        
        local primes = {2,3}
        -- All primes above 2 and 3 fit the formula 6n±1 for natural n.
        local cliche = {true, false, true, false, false, false}
        local sieve = {false, true, true, false}

        -- Sieve is the fastest but most memory-hungry way of finding primes.
        
        function extend(to)
            local i = 1
            while #sieve < to do
                sieve[#sieve + 1] = cliche[i]
                if i == 6 then
                    i = 1
                else
                    i = i + 1
                end
            end
        end

        extend(1e6)

        local p = 5
        
        while #primes < n do
            if sieve[p] then
                for i = p*p, #sieve, 2*p do
                    sieve[i] = false
                end

                primes[#primes + 1] = p
            end

            p = p + 1
        end

        return primes[n]
end
--]]