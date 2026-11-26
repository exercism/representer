#!/usr/bin/env tclsh

# ----------------------------------------------------------------------------
# exercism.org
# Tcl Track Exercise: etl
# Contributed: Anthony J. Borla (ajborla@bigpond.com)
# ----------------------------------------------------------------------------

proc transform {input} {
    # Reject odd-numbered element input list
    if {![expr [llength $input] % 2 == 0]} {
        return -code error "invalid input"
    }

    #
    # Traverse input, converting each entry from:
    #   point { letters ... }
    # to:
    #   { letterA point letterB point ... }
    #
    foreach {point letters} $input {
        foreach {letter} $letters {
            set points([string tolower $letter]) $point
        }
    }

    # Return sorted (by letter, ascending) list from `points` array
    return [lsort -stride 2 -index 0 [array get points]]
}
