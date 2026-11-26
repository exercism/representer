# Extract the limit from the input
.limit as $limit |

# For numbers less than 2, there are no primes
if $limit < 2 then
  []
else
  # Create a sequence of all numbers from 2 to limit
  [range(2; $limit + 1)] |
  
  # Apply the sieve of Eratosthenes
  reduce range(0; length) as $i (
    .;
    
    # Current number being checked
    .[$i] as $current |
    
    # If current number is not 0 (not marked as composite yet)
    if $current != 0 then
      # Mark all multiples as composite (0)
      reduce range($i + $current; length; $current) as $j (
        .;
        .[$j] = 0
      )
    else
      .
    end
  ) |
  
  # Keep only the non-zero values (the primes)
  map(select(. != 0))
end