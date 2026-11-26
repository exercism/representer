proc raindrops {number} {
    if {$number%3 eq 0} { append r "Pling" }
    if {$number%5 eq 0} { append r "Plang" }
    if {$number%7 eq 0} { append r "Plong" }
    if {[info exists r] eq 0} { append r $number }
    return $r
}