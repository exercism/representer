proc abbreviate {phrase} {
    set abb [string index $phrase 0]
    set phrase [string map {"'" ""} $phrase]
    for {set i 0} {$i < [string length $phrase]} {incr i} {
        if {[string is alpha -strict [string index $phrase $i]] == 0} {
            append abb [string index $phrase [expr $i + 1]]
        }
    }
    set abb [string map {"-" "" "_" "" " " ""} $abb]
    return [string toupper $abb]
}
