proc verse {n} {
    set n [expr $n-1]
    set day [list first second third fourth fifth sixth seventh eighth ninth tenth eleventh twelfth]
    
    set item [list [list a Partridge in a Pear Tree.] [list two Turtle Doves] [list three French Hens] [list four Calling Birds] [list five Gold Rings] [list six Geese-a-Laying] [list seven Swans-a-Swimming] [list eight Maids-a-Milking] [list nine Ladies Dancing] [list ten Lords-a-Leaping] [list eleven Pipers Piping] [list twelve Drummers Drumming]]
    
    set song "On the [lindex $day $n] day of Christmas my true love gave to me: [lindex $item $n]"


    while {$n > 0} {    
        if {$n == 1} {append song ", and"} else {append song ","}
        append song " [lindex $item [expr $n-1]]"
        set n [expr $n-1]
    }

    return $song
}

proc sing {from to} {
    set song ""
    
    while {$from <= $to} {
        append song "[verse $from]\n"
        incr from
    }
    set song [string trimright $song "\n"]
    return $song   
}
