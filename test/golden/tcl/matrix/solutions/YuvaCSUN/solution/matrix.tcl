proc matrixFrom {inputString} {
    split $inputString "\n"
}

proc row {matrix n} {
    lindex $matrix $n-1
}

proc column {matrix n} {
    lmap row $matrix {lindex $row $n-1}
}