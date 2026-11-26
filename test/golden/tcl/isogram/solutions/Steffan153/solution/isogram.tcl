proc isIsogram {input} {
    set dict {}
    set count 0
    foreach item [split $input ""] {
        if {$item ne " " && $item ne "-"} {
            dict set dict [string tolower $item] ""
            incr count
        }
    }
    expr {[dict size $dict] == $count}
}
