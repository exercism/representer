proc abbreviate {phrase} {
    set result {};
    foreach word [split $phrase {"" - _}] {
        append result [string toupper [string index $word 0]];
    }
    return $result;
}