proc abbreviate {phrase} {
    set parts [split $phrase " ,-"]
    set answer {}

    foreach {part} $parts {
        set full_match ""
        set group_match ""
        regexp {([a-zA-Z])} $part full_match group_match
        lappend answer $group_match
    }

    set answer [join $answer ""]
    set answer [string toupper $answer]

    return $answer
}
