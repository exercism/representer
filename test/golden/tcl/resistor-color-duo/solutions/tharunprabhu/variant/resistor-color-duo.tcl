namespace eval ::resistorColor {
    proc value {args} {
        if {[llength $args] == 0} {
        error "No argumenus provided."
        } else {
        set value ""
        set colorlist {black brown red orange yellow green blue violet grey white}
        foreach color $args {
            set appendval [lsearch -exact $colorlist $color]
            if { $appendval == -1 } {
                error "Invalid color"
            }
            append value $appendval
        }
        set value [string range $value 0 1]
        if { [string index $value 0] == 0 } {
            set value [string index $value 1]
        }
        return $value
    }
    }
}
