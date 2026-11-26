proc matrixFrom {inputString} {
    return [split $inputString "\n"]
}

proc row {matrix n} {
    return [lindex $matrix [expr {$n-1}]]
}

proc column {matrix n} {
    set i [expr {$n-1}]

    set res [list]
    foreach row $matrix {
        lappend res [lindex $row $i]
    }
    return $res
}
