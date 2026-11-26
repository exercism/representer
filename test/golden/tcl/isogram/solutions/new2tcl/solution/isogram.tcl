proc isIsogram {input} {
    set cache {}
    regsub -all {[^a-z]} [ string tolower $input] "" input
    foreach ch [split $input {}] {
        if { [lsearch $cache $ch] == -1 } {
            lappend cache $ch
        } else { 
            return false
        }
    }
    return true
}