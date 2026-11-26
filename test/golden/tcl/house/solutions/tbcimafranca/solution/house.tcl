proc recite {from to} {
    set subjects [list \
        "house that Jack built" \
        "malt" \
        "rat" \
        "cat" \
        "dog" \
        "cow with the crumpled horn" \
        "maiden all forlorn" \
        "man all tattered and torn" \
        "priest all shaven and shorn" \
        "rooster that crowed in the morn" \
        "farmer sowing his corn" \
        "horse and the hound and the horn"]

    set actions [list \
        "" \
        "lay in" \
        "ate" \
        "killed" \
        "worried" \
        "tossed" \
        "milked" \
        "kissed" \
        "married" \
        "woke" \
        "kept" \
        "belonged to"]

    set verses [list]

    for {set verse $from} {$verse <= $to} {incr verse} {
        set index [expr {$verse - 1}]
        set sentence "This is the [lindex $subjects $index]"

        for {set i $index} {$i > 0} {incr i -1} {
            append sentence " that [lindex $actions $i] the [lindex $subjects [expr {$i - 1}]]"
        }

        append sentence "."
        lappend verses $sentence
    }

    return [join $verses "\n"]
}