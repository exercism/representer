unit module Sieve;

#| Find all prime numbers less than or equal to the given limit using the Sieve of Eratosthenes
sub find-primes(Int $limit) is export {
    # Handle edge cases
    return () if $limit < 2;
    
    # Create a boolean array to mark non-prime numbers
    # Initially all numbers are unmarked (potentially prime)
    my @is-composite = False xx ($limit + 1);
    
    # Create an array to store the prime numbers
    my @primes;
    
    # Apply the Sieve of Eratosthenes algorithm
    for 2..$limit -> $i {
        # If $i is not marked as composite, it's prime
        if !@is-composite[$i] {
            # Add $i to the list of primes
            @primes.push($i);
            
            # Mark all multiples of $i as composite (not prime)
            # Start from $i*$i since smaller multiples would have been marked already
            my $j = $i * $i;
            while $j <= $limit {
                @is-composite[$j] = True;
                $j += $i;  # Move to the next multiple
            }
        }
    }
    
    return @primes;
}