proc luhn {digits} {
    set digits [join [split $digits " "] ""]
    if {[string length $digits] < 2} {
        return false
    }
    if {[string is digit $digits] == 0} {
        return false
    }
    puts digits:$digits
    for {set i [expr {[string length $digits] - 2}]} {$i >= 0} {incr i -2} {
        if {[string index $digits $i] * 2 > 9} {
            set digits [string replace $digits $i $i [expr {[string index $digits $i] * 2 - 9}]]
        } else {
            set digits [string replace $digits $i $i [expr {[string index $digits $i] * 2}]]
        }
    }
    set sum 0
    foreach i [split $digits {}] {
        incr sum $i
    }
    if {[expr {$sum % 10}] == 0} {
        return true
    } else {
        return false
    }
}

