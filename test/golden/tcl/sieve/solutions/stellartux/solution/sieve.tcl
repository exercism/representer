proc primes {limit} {
    set is_prime {}
    for {set i 0} {[expr $i <= $limit]} {incr i} {
        lappend is_prime false
    }
    lset is_prime 2 true
    for {set i 3} {[expr $i <= $limit]} {incr i 2} {
        lset is_prime $i true
    }
    for {set i 3} {[expr $i <= $limit]} {incr i 2} {
        for {set j [expr $i * $i]} {[expr $j <= $limit]} {incr j $i} {
            lset is_prime $j false
        }
    }
    set result {}
    for {set i 2} {[expr $i <= $limit]} {incr i} {
        if {[lindex $is_prime $i]} {
            lappend result $i
        }
    }
    return $result
}
