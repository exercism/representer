proc isIsogram {input} {
    set char_list [regexp -all -inline {\w} [string tolower $input]]
    set count [dict create]

    foreach char $char_list {
        dict incr count $char 1
        if {[dict get $count $char ] > 1} {return false}
    }
    return true
}