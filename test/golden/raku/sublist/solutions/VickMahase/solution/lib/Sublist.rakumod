unit module Sublist;

#| Compare two lists and determine their relationship: equal, sublist, superlist, or unequal
sub compare-lists(@a, @b) is export {
    # Equal check: if both lists have the same elements in the same order
    return "equal" if @a eqv @b;
    
    # Handle empty list cases
    return "sublist" if @a.elems == 0 && @b.elems > 0;
    return "superlist" if @a.elems > 0 && @b.elems == 0;
    
    # Check if list A is a sublist of B
    if is-sublist(@a, @b) {
        return "sublist";
    }
    
    # Check if list A is a superlist of B
    if is-sublist(@b, @a) {
        return "superlist";
    }
    
    # If none of the above conditions are met
    return "unequal";
}

#| Helper function to check if list a is a sublist of list b
sub is-sublist(@a, @b) {
    # If first list is empty, it's always a sublist
    return True if @a.elems == 0;
    
    # If second list is smaller than the first, it can't contain first list as a sublist
    return False if @a.elems > @b.elems;
    
    # Check each possible starting position in list b
    for 0..(@b.elems - @a.elems) -> $start {
        my $match = True;
        
        # Compare each element of a with corresponding element in b
        for 0..^@a.elems -> $i {
            if @a[$i] !== @b[$start + $i] {
                $match = False;
                last;
            }
        }
        
        # If we found a match, a is a sublist of b
        return True if $match;
    }
    
    # No match found
    return False;
}