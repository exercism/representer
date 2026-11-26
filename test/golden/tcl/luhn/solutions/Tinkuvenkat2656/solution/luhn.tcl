proc luhn {digits} {
    # remove whitespace
    regsub -all {\s+} $digits {} digits

    if { [string length $digits] <= 1 } {
        return false
    }
    if { [regexp {[^0-9]} $digits] } {
        # only supports base 10 digits
        return false
    }

    set tot 0
    set ctr 1
    # since we start from the right, simply reverse the string
    foreach d [split [string reverse $digits] ""] {
        if { $ctr % 2 == 0 } {   
            # double and possibly deduct from the value
            set d [expr {2 * $d}]
            set d [expr $d > 9 ? [expr {$d - 9}] : $d] 
        }
        incr tot $d
        incr ctr
    }
     
    return [expr { $tot % 10 == 0 }]
}