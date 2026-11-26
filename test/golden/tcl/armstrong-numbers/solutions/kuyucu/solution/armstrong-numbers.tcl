proc isArmstrongNumber {number} {
    set length [string length $number]
    set digits [split $number {}]
    set sum 0
    foreach  digit $digits {
        set sum [expr $sum + $digit ** $length]         
    }

    return [expr $sum == $number]
}
