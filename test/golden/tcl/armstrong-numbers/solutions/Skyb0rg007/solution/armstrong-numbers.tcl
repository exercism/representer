proc isArmstrongNumber {number} {
    set len [string length $number]
    foreach digit [split $number ""] {
        incr sum [expr {$digit ** $len}]
    }
    expr {$sum == $number}
}
