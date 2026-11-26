proc hammingDistance {left right} {
    if {[string length $left] != [string length $right]} {
        return -code error "strands must be of equal length";
    }
    if {$left eq $right} {
        return 0;
    };

    set distance 0;
    for {set i 0} {$i < [string length $left]} {incr i} {
        if {[string index $left $i] != [string index $right $i]} {
            incr distance;
        }
    }
    return $distance;
}