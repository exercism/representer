unit module NthPrime;

sub nth-prime ($n) is export {
    # Input validation: n must be a positive integer.
    # The tests expect the function to die for values less than 1.
    die "there is no zeroth prime" if $n < 1;
    
    # Handle the first prime as a special case to simplify the loop.
    return 2 if $n == 1;

    # Maintain an array of primes found so far.
    # We will use these for trial division to check candidates.
    my @primes = [2];
    my $candidate = 3;

    # Continue searching until the length of our prime list reaches $n.
    while @primes.elems < $n {
        my $is-prime = True;
        my $limit = $candidate.sqrt.Int;
        
        # Trial division: A number is prime if it is not divisible by any prime
        # less than or equal to its square root.
        for @primes -> $p {
            if $p >= $limit {
                # Optimization: No need to check factors larger than the square root.
                last;
            }
            if $candidate %% $p {
                # The %% operator checks for divisibility (remainder is 0).
                $is-prime = False;
                last;
            }
        }
        
        if $is-prime {
            @primes.push: $candidate;
        }
        
        # Skip even numbers by incrementing by 2.
        $candidate += 2;
    }

    # Return the last element in our list, which is the n-th prime.
    return @primes.tail;
}