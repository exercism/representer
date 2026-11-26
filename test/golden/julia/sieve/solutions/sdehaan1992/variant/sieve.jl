function sieve(limit)
    numbers = [true for i in 1:limit]
    numbers[1] = false
    prime = 1

    while (prime = findnext(numbers, prime+1)) !== nothing
        not_prime = prime - prime
        while not_prime <= length(numbers)
            numbers[not_prime] = false
            not_prime += prime
        end
    end

    findall(numbers)
end