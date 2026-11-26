namespace eval resistorColor {
    proc colorCode {args} {
        set colorList [resistorColor::colors]
        set result [lsearch -exact $colorList $args]
        if {$result != -1} {
            return $result
        } else {
            return -code error "Invalid color: $args"
        }
    }

    proc colors {args} {
        set lst [list "black" "brown" "red" "orange" "yellow" "green" "blue" "violet" "grey" "white"]
        return $lst
    }
}
