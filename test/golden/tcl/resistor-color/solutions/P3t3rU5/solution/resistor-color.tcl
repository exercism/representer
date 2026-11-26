namespace eval resistorColor {
    variable COLORS [dict create \
        black   0 \
        brown   1 \
        red     2 \
        orange  3 \
        yellow  4 \
        green   5 \
        blue    6 \
        violet  7 \
        grey    8 \
        white   9 \
    ]
    proc colorCode {args} {
        variable COLORS

        if {[dict exists $COLORS $args]} {
            return [dict get $COLORS $args]
        }
        error "Invalid color: $args"
    }

    proc colors {args} {
        variable COLORS
        dict keys $COLORS
    }
}
