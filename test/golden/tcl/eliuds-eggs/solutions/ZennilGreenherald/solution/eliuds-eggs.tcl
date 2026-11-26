proc eggCount {number} {
    set ct 0
    while {$number > 0} {
        if {$number % 2 == 1} {
            incr ct
        }
        set number [expr {int($number / 2)}]
    }
    return $ct
}
