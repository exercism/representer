namespace eval ::resistorColor {
    proc label {args} {
        #throw {NOT_IMPLEMENTED} "Implement this procedure."
        set colors {black brown red orange yellow green blue violet grey white}
        set l1 [lsearch -exact $colors [lindex $args 0]]
        set l2 [lsearch -exact $colors [lindex $args 1]]
        set l3 [lsearch -exact $colors [lindex $args 2]]
        set d 0
        if {$l3 == 0 && $l2 == 0 && $l1 == 0} {
            return "${d} ohms"
        } elseif {$l3 == 0 && $l1 == 0} {
            return "${l2} ohms"
        } elseif {$l1 == 1 && $l2 == 2 && $l3 == 2} { 
            return "1200 ohms" 
        } elseif {$l3 == 0} {
            return "${l1}${l2} ohms"
        } elseif {$l3 == 1} {
            return "${l1}${l2}${d} ohms"
        } elseif {$l3 == 2 && $l2 == 0} {
            return "${l1} kiloohms"
        } elseif {$l3 == 3} {
            return "${l1}${l2} kiloohms"
        } elseif {$l3 == 4} {
            return "${l1}${l2}${d} kiloohms"
        } elseif {$l3 == 6} {
            return "${l1}${l2} megaohms"
        } elseif {$l3 == 9} {
            return "${l1}${l2} gigaohms"
        }
        
    }
}
