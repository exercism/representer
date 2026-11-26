namespace eval resistorColor {
    variable colorCodes \
        [list "black" "brown" "red" "orange" "yellow" \
              "green" "blue" "violet" "grey" "white"]
    
    proc colorCode {args} {
        variable colorCodes

        set rval [lsearch -exact $colorCodes [string tolower $args]]
        if {$rval == -1} {
            throw -1 "Invalid color: $args"
        } else {
            return $rval
        }
    }

    proc colors {args} {
        variable colorCodes
        return $colorCodes
    }
}
