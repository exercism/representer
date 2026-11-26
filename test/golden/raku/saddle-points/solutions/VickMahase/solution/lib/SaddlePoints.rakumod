unit module SaddlePoints;

#| Finds all saddle points in a matrix.
#| A saddle point is an element which is the maximum in its row 
#| and the minimum in its column.
sub saddle-points( @matrix ) is export {
    # Handle empty matrix or matrix with an empty row (e.g., [[],])
    return [] if !@matrix || !@matrix[0] || @matrix[0].elems == 0;

    my $num-rows = @matrix.elems;
    my $num-cols = @matrix[0].elems;

    # 1. Pre-calculate the maximum height for every row.
    # Map each row to its maximum value.
    my @row-maxima = @matrix.map({ .max });

    # 2. Pre-calculate the minimum height for every column.
    # We iterate through column indices and extract the values to find the min.
    my @col-minima;
    for 0 ..^ $num-cols -> $c {
        my @column = @matrix.map({ .[$c] });
        @col-minima[$c] = @column.min;
    }

    # 3. Identify coordinates that satisfy both conditions.
    my @points;
    for 0 ..^ $num-rows -> $r {
        for 0 ..^ $num-cols -> $c {
            my $val = @matrix[$r][$c];
            
            # If the current tree is the largest in its row AND the smallest in its column,
            # it is a candidate for the tree house.
            if $val == @row-maxima[$r] && $val == @col-minima[$c] {
                # The exercise requires 1-based indexing for the output.
                @points.push: [$r + 1, $c + 1];
            }
        }
    }

    return @points;
}