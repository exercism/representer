unit module SumOfMultiples;

#| Calculate the sum of all unique multiples of the given factors that are less than the limit
sub sum-of-multiples(:@factors, :$limit) is export {
    # Handle edge cases
    return 0 if @factors.elems == 0 && $limit <= 1;
    
    # Filter out zero and collect valid factors
    my @valid-factors = @factors.grep: * > 0;
    
    # Create a set to store all unique multiples
    my $multiples = SetHash.new;
    
    # For each factor, find all its multiples less than the limit
    for @valid-factors -> $factor {
        # Calculate the number of multiples less than the limit
        my $count = ($limit - 1) div $factor;
        
        # Add each multiple to the set
        for (1..$count) -> $i {
            $multiples{$factor * $i} = True;
        }
    }
    
    # Sum all unique multiples
    return $multiples.keys.sum;
}