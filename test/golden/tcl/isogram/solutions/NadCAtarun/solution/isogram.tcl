proc isIsogram {input} {
    set l [regexp -all -inline {[[:alpha:]]} [string tolower $input]]
    return [expr {[llength $l] == [llength [lsort -unique $l]]}]
}
