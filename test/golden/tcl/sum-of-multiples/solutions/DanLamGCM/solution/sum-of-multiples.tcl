proc sumOfMultiples {factors limit} {
    set output 0
    set joinedList [list]
    foreach item $factors {
        lappend joinedList {*}[multiplesBelow $limit $item]
    }
    set uniqList [lsort -unique $joinedList]
    foreach item $uniqList {incr output $item}
    return $output
}

proc multiplesBelow {m b} {
    set output [list]
    if {$b == 0} {return $output}
    for {set i $b} {$i < $m} {incr i $b} {
        lappend output $i
    }
    return $output
}
