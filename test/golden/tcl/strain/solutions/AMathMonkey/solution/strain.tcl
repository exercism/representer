  
proc keep {varname list condition {keep true}} {
    set result [list]
    foreach item $list {
        set $varname $item
        if {!!$keep == !![eval $condition]} {
            lappend result $item
        }
    }
    return $result
}

proc discard {varname list condition} {
    keep $varname $list $condition false
}
