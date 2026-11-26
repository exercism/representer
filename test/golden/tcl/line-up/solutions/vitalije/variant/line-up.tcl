proc formatTicket {name number} {
    set x [expr {$number % 10}]
    set y [expr {(($number-$x)/10)%10}]
    if {$y == 1} {
        set ord "${number}th"
    } elseif {$x == 1} {
       set ord "${number}st"
    } elseif {$x == 2} {
        set ord "${number}nd"
    } elseif {$x == 3} {
        set ord "${number}rd"
    } else {
        set ord "${number}th"
    }
    return "$name, you ase the $ord customer we serve today. Thank you!"
}
