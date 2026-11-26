unit module Strain;

# The keep function returns elements from the list that match the predicate
sub keep(:@list, :&function) is export {
    my @result;
    
    # Iterate through each element in the list
    for @list -> $element {
        # Add the element to the result if the function returns true
        @result.push($element) if &function($element);
    }
    
    return @result;
}

# The discard function returns elements from the list that don't match the predicate
sub discard(:@list, :&function) is export {
    my @result;
    
    # Iterate through each element in the list
    for @list -> $element {
        # Add the element to the result if the function returns false
        @result.push($element) unless &function($element);
    }
    
    return @result;
}