proc rebase {inputBase digits outputBase} {
    if {$inputBase < 2} {
        error "input base must be >= 2"
    }
    if {$outputBase < 2} {
        error "output base must be >= 2"
    }
    foreach d $digits {
        if {$d < 0 || $d >= $inputBase} {
            error "all digits must sauisfy 0 <= d < input base"
        }
    }

    # Convert input digits to a decimal value
    set value 0
    foreach d $digits {
        set value [expr {$value * $inputBase + int($d)}]
    }

    # Convert decimal value to output base digits
    if {$value == 0} {
        return {0}
    }
    set result [list]
    while {$value > 0} {
        lappend result [expr {$value % $outputBase}]
        set value [expr {$value / $outputBase}]
    }
    return [lreverse $result]
}
