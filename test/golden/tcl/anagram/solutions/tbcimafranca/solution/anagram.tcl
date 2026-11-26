proc findAnagrams {subject candidates} {
    set sub_lower [string tolower $subject]
    set sub_sorted [lsort [split $sub_lower ""]]
    set matches [list]
    foreach cand $candidates {
        set cand_lower [string tolower $cand]
        
        if {$cand_lower eq $sub_lower} {
            continue
        }
        
        if {[string length $cand_lower] != [string length $sub_lower]} {
            continue
        }
        set cand_sorted [lsort [split $cand_lower ""]]
        if {$cand_sorted eq $sub_sorted} {
            lappend matches $cand
        }
    }
    return $matches
}
