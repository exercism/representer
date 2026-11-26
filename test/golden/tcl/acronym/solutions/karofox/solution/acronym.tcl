proc abbreviate {phrase} {
    set phrase [regsub -all {[^[:alpha:]']} $phrase " "]
    set acronym ""
    foreach word [split $phrase] {
        append acronym [string range $word 0 0]
    }

    return [string toupper $acronym]
}
