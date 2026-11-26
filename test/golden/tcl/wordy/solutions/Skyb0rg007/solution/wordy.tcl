
oo::class create Scanner {
    variable str index

    constructor {input} {
        set str [string trimright $input " ?"]
        set index 0
    }

    method next {{valueVar ""}} {
        if {$valueVar ne ""} {upvar $valueVar value}
        my SkipWhitespace
        if {[my AtEOF]} {
            return EOF
        } elseif {[my TryParse "plus"]} {
            return ADD
        } elseif {[my TryParse "minus"]} {
            return SUB
        } elseif {[my TryParse "multiplied by"]} {
            return MUL
        } elseif {[my TryParse "divided by"]} {
            return DIV
        } else {
            return [my TryParseNum value]
        }
    }

    method AtEOF {} {
        expr {$index == [string length $str]}
    }

    method TryParseNum {valueVar} {
        upvar $valueVar value
        set i $index
        if {[string index $str $i] eq "-"} {incr i}
        set j $i
        while {[string is digit -strict [string index $str $j]]} {
            incr j
        }
        if {$i < $j} {
            set value [string range $str $index $j]
            set index $j
            return NUM
        } else {
            return ERR
        }
    }

    method TryParse {s} {
        set len [string length $s]
        if {[string range $str $index [expr {$index+$len-1}]] eq $s} {
            incr index $len
            return true
        } else {
            return false
        }
    }

    method SkipWhitespace {} {
        while {[string is space -strict [string index $str $index]]} {
            incr index
        }
        my TryParse "What is"
        while {[string is space -strict [string index $str $index]]} {
            incr index
        }
        if {[string index $str $index] eq "?"} {
            incr index
        }
    }
}

proc answer {question} {
    set scanner [Scanner new $question]

    set tok [$scanner next n]
    if {$tok eq "ERR"} {return -code error "unknown operation"}
    if {$tok ne "NUM"} {return -code error "syntax error"}
    while {true} {
        set op [$scanner next]
        if {$op eq "EOF"} {break}
        if {$op eq "ERR"} {return -code error "unknown operation"}
        if {$op eq "NUM"} {return -code error "syntax error"}
        set tok [$scanner next m]
        if {$tok ne "NUM"} {return -code error "syntax error"}
        switch $op {
            ADD {set n [expr {$n + $m}]}
            SUB {set n [expr {$n - $m}]}
            MUL {set n [expr {$n * $m}]}
            DIV {set n [expr {$n / $m}]}
        }
    }
    $scanner destroy
    return $n
}
