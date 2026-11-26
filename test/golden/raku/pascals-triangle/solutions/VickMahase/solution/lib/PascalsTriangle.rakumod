unit module PascalsTriangle;

#| Generate Pascal's triangle up to the specified number of rows
sub pascals-triangle($rows) is export {
    # Handle zero rows case
    return () if $rows == 0;
    
    # For rows > 0, build the triangle
    my @triangle = [];
    
    for 0..^$rows -> $n {
        # Create an array for the current row
        my @row = [];
        
        # First element is always 1
        @row.push(1);
        
        # Calculate middle elements for rows beyond the first
        if $n > 0 {
            my @prev = @triangle[$n - 1].list;
            
            for 0..^($n - 1) -> $j {
                @row.push(@prev[$j] + @prev[$j + 1]);
            }
            
            # Last element is always 1 (for rows beyond the first)
            @row.push(1);
        }
        
        # Add the row to the triangle, converting to an immutable List
        @triangle.push(@row.item);
    }
    
    # Return the triangle as an immutable List
    return @triangle.item;
}