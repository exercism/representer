proc hammingDistance {left right} {
    set len_left [string length $left]
    set len_right [string length $right]
    if {$len_left != $len_right} {
        error "strands must be of equal length"
    }

    set diff 0
    for {set i 0} {$i<$len_left} {incr i} {
        if {[string index $left $i] eq [string index $right $i]} {
            continue
        } else {
            set diff [expr {$diff+1}]
        }
    }
    return $diff
}
