proc abbreviate {phrase} {
    # throw {NOT_IMPLEMENTED} "Implement this procedure."
    set res {}
    foreach word  [ split $phrase " _-" ] {
        puts $word
        set firstChar [ string toupper [ string index $word 0 ] ]
        append res $firstChar
    }
    return $res
}
