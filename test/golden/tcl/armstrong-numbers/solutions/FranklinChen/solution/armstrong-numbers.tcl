proc pow {base exp} {
    set result 1
    while {$exp > 0} {
        if {$exp % 2 == 1} {
            set result [expr {$result * $base}]
        }
        set base [expr {$base * $base}]
        set exp [expr {$exp / 2}]
    }
    return $result
}

proc isArmstrongNumber {number} {
    if {$number == 0} { return 1 }
    
    set numDigits [expr {int(log10($number)) + 1}]
    set sumPowers 0
    set remaining $number

    while {$remaining != 0} {
        set digit [expr {$remaining % 10}]
        set sumPowers [expr {$sumPowers + [pow $digit $numDigits]}]
        if {$sumPowers > $number} {
            return 0
        }
        set remaining [expr {$remaining / 10}]
    }

    return [expr {$sumPowers == $number}]
}