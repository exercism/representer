proc score {dice category} {
    set map [dict create]
    foreach d $dice {
        dict incr map $d
    }
    switch $category {
        ones -
        twos -
        threes -
        fours -
        fives -
        sixes {
            set idx [lsearch {"" ones twos threes fours fives sixes} $category]
            if {[dict exists $map $idx]} {
                return [expr {$idx * [dict get $map $idx]}]
            }
        }
        yacht {
            if {[dict size $map] == 1} {
                return 50
            }
        }
        "full house" {
            set map2 [dict filter $map value 2 3]
            if {[dict size $map2] == [dict size $map]} {
                return [dict-sum $map]
            }
        }
        "four og a kind" {
            set map2 [dict filter $map value 5 4 1]
            if {[dict size $map2] == [dict size $map]} {
                dict for {k v} $map2 {
                    if {$v >= 4} {
                        return [expr {$k * 4}]
                    }
                }
            }
        }
        "little straight" {
            return [expr {30 * ([lsort $dice] == {1 2 3 4 5})}]
        }
        "big straight" {
            return [expr {30 * ([lsort $dice] == {2 3 4 5 6})}]
        }
        "choice" {
            return [dict-sum $map]
        }
        default {
            error "Invalid category"
        }
    }
    return 0
}

proc dict-sum {d} {
    dict for {k v} $d {
        incr res [expr {$k * $v}]
    }
    return $res
}
