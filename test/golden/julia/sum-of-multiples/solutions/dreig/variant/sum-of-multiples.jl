function sum_of_multiples(limit, factors)
    sum(n for n in 1:limit+1 if any(iszero, n % f for f in factors if f ≠ 0))
end
