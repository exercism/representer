# Returns a list of successively reduced values of $lst
proc lscan {func lst} {
    set len [llength $lst]
    if {$len == 0} {return {}}
    set acc [lindex $lst 0]
    set res [list $acc]
    for {set i 1} {$i < $len} {incr i} {
        lappend res [set acc [$func $acc [lindex $lst $i]]]
    }
    return $res
}

# Returns 1-based indices of the extreme elements of $lst
# $func should be associative, commutative and idempotent
proc localExtrema {func lst} {
    set lex [lscan $func $lst]
    set rex [lreverse [lscan $func [lreverse $lst]]]
    set indices {}
    set i 1
    foreach x $lst l $lex r $rex {
        if {[$func $x $l $r] == $x} {
            lappend indices $i
        }
        incr i
    }
    return $indices
}

# Returns the transposed matrix
proc transpose {matrix} {
    set n [llength $matrix]
    set m [llength [lindex $matrix 0]]
    set cols {}
    for {set i 0} {$i < $n} {incr i} {
        for {set j 0} {$j < $m} {incr j} {
            lset cols $j $i [lindex $matrix $i $j]
        }
    }
    return $cols
}

proc saddlePoints {matrix} {
    set tallIndices {}
    set rowNum 1
    foreach row $matrix {
        foreach idx [localExtrema ::tcl::mathfunc::max $row] {
            lappend tallIndices [list $rowNum $idx]
        }
        incr rowNum
    }

    set indices {}
    set colNum 1
    foreach col [transpose $matrix] {
        foreach idx [localExtrema ::tcl::mathfunc::min $col] {
            set shortIndex [list $idx $colNum]
            if {$shortIndex in $tallIndices} {
                lappend indices $shortIndex
            }
        }
        incr colNum
    }

    return $indices
}
