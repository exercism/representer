proc countWords {sentence} {
    set counts [dict create]
    variable lowered [string tolower $sentence]
    variable replaced [regsub -all {[^a-z0-9']} $lowered " "]
    foreach word $replaced {
        set word [string trim $word {'}]
        if {$word eq ""} {
            continue
        } else {
            dict incr counts $word
        }
    }
    return $counts
}
