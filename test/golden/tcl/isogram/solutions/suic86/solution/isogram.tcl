proc isIsogram {input} {
    set chars [dict create]
    foreach char [split [string tolower $input] ""] {
        if {[dict exists $chars $char]} {
            return 0 
        }
        if {[string is alpha $char]} {
            dict set chars $char 0
        }
    }
    return 1
}
