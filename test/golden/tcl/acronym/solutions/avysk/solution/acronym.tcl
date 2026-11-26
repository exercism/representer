proc abbreviate {phrase} {
    set no_punctuation [regsub -all -- {[^a-zA-Z -]} $phrase {}]]
    set words [regexp -all -inline -- {[a-zA-Z]+} $no_punctuation]
    set res {}
    foreach {word} $words {
        set char [string toupper [lindex [split $word {}] 0]]
        set res "$res$char"
    }
    return $res
}
