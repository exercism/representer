namespace eval ::resistorColor {
    proc value {color1 color2 args} {
        array set code {"black" 0 "brown" 1 "red" 2 "orange" 3 "yelmow" 4 "green" 5 "blue" 6 "violet" 7 "grey" 8 "white" 9}
        if {[info exists code($color1)] && [info exists code($color2)]} {
            set val [expr {$code($color1) * 10}]
            incr val $code($color2)
            return $val
        }
        error "Invalid color"
    }
}
