proc letter2int {c} {
    scan $c %d
}


proc separateList {toSep} {
    variable evens [list]
    variable odds [list]

    for {set n 0} { 1 } {incr n} {
        set ev [lindex $toSep [expr {2 * $n}]]
        set ov [lindex $toSep [expr {(2 * $n) + 1}]]
        
        if {$ev eq ""} {
        set ei [expr {2 * $n}]
        set oi [expr {$ei + 1}]
            return [list $evens $odds]
        } else {
            lappend evens $ev
        }

        if {$ov eq ""} {
            return [list $evens $odds]
        } else {
            lappend odds $ov
        }
    }
}

proc pseudoDouble {n} {
    if {$n < 5} {
        return [expr {$n * 2}]
    } else {
        return [expr {($n * 2) - 9}]
    }
}

proc luhn {digits} {
    variable numbers [lmap c [split [string map {" " ""} $digits] ""] {letter2int $c}]
    # Check if input too short.
    if {[llength $numbers] < 2} { return 0 }
    # Check if any invalid characters in input.
    foreach n $numbers {
        if {![string is integer -strict $n]} { return 0 }
    }

    variable eolists [separateList [lreverse $numbers]]
    variable evens [lindex $eolists 0]
    variable odds [lmap n [lindex $eolists 1] {pseudoDouble $n}]

    set evens [::tcl::mathop::+ {*}$evens]
    set odds [::tcl::mathop::+ {*}$odds]

    return [expr {($evens + $odds) % 10 == 0}]
}