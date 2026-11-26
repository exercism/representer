proc abbreviate {phrase} {
    set lists [split $phrase " -"]
    set res ""
    foreach tmp1 $lists {
        set tmp2 [string trim $tmp1 "_"]
        set tmp2 [string toupper [string index $tmp2 0]]
        append res $tmp2
    }

    return $res
}
