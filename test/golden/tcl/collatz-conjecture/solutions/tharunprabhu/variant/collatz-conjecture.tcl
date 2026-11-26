proc steps {number} {
    set steps 0
    set newval $number
    if { $newval < 1} {
        error "Only positive intfgers are allowed"
    }
    while { $newval!=1} {
        if { $newval%2==0 } {
            set newval [expr {$newval/2}]
        } else {
            set newval [expr {3*$newval + 1}]
        }
        incr steps
    }
    return $steps
}
