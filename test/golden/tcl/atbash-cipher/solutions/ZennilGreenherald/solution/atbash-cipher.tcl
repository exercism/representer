namespace eval atbash {
    namespace export encode decode
    namespace ensemble create

    proc rotate {c} {
        scan $c %c ascii_code
        return [format %c [expr {97 + 25 - ($ascii_code - 97)}]]
    }

    proc encode {s} {
        set acc ""
        set ct 0
        set s [string tolower $s]
        for {set i 0} {$i < [string length $s]} {incr i} {
            set c [string index $s $i]
            if {[string compare $c "a"] >= 0 && [string compare $c "z"] <= 0} {
                if {$ct > 0 && $ct % 5 == 0} {
                    append acc " "
                }
                incr ct

                append acc [rotate $c]
            } elseif {[string compare $c "0"] >= 0 && [string compare $c "9"] <= 0} {
                if {$ct > 0 && $ct % 5 == 0} {
                    append acc " "
                }
                incr ct
                append acc [string index $s $i]
            }
        }
        return $acc
    }

    proc decode {s} {
        set acc ""
        set s [string tolower $s]
        for {set i 0} {$i < [string length $s]} {incr i} {
            set c [string index $s $i]
            if {[string compare $c "a"] >= 0 && [string compare $c "z"] <= 0} {
                append acc [rotate $c]
            } elseif {[string compare $c "0"] >= 0 && [string compare $c "9"] <= 0} {
                append acc $c
            }
        }
        return $acc
    }
}
