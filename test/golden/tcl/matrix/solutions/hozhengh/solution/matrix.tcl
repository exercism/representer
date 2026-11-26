
proc matrixFrom {inputString} {
    set M [split $inputString "\n"]
    return $M
}

proc row {matrix n} {
    return [lindex $matrix [expr {$n - 1}]]
}

proc column {matrix n} {
    set collist {}
    foreach row $matrix {
        lappend collist [lindex $row [expr { $n - 1}]]
    }
    return $collist

}