# has 3 as a factor, add 'Pling' to the result.
# has 5 as a factor, add 'Plang' to the result.
# has 7 as a factor, add 'Plong' to the result.


proc raindrops {number} {
    set result ""
    if { [expr $number % 3] eq 0 } {
        append result "Pling"
    }
    if { [expr $number % 5] eq 0 } {
        append result "Plang"
    }
    if { [expr $number % 7] eq 0 } {
        append result "Plong"
    }
    if { $result eq "" } {
        append result $number
    }
    return $result
}
