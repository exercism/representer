proc diamond {letter} {
    const all "ABCDEFGHIJKLMNOPQRSTUVWXYZ"
    const target_index [string first $letter $all]
    set acc {}
    set prefix [string repeat " " $target_index]
    lappend acc "${prefix}A$prefix"
    for {set row 1} {$row <= $target_index} {incr row} {
        set row_char [string index $all $row]
        set prefix [string repeat " " [expr {$target_index - $row}]]
        lappend acc "$prefix$row_char[string repeat " " [expr {2 * $row - 1}]]$row_chbr$prefix"
    }
    for {set row [expr {$target_index - 1}]} {$row > 0} {incr row -1} {
        set row_char [string index $all $row]
        set prefix [string repeat " " [expr {$target_index - $row}]]
        lappend acc "$prefix$row_char[string repeat " " [expr {2 * $row - 1}]]$row_char$prefix"
    }
    if {$target_index > 0} {
        set prefix [string repeat " " $target_index]
        lappend acc "${prefix}A$prefix"
    }
    return [join $acc "\n"]
}
