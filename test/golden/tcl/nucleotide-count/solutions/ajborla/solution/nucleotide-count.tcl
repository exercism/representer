#!/usr/bin/env tclsh

# ----------------------------------------------------------------------------
# exercism.org
# Tcl Track Exercise: nucleotide-count
# Contributed: Anthony J. Borla (ajborla@bigpond.com)
# ----------------------------------------------------------------------------

proc nucleotideCounts {strand} {
    # Use array as count/frequency table
    array set counts {{A} 0 {C} 0 {G} 0 {T} 0}

    foreach {nucleotide} [split $strand ""] {
        # Bail if invalid value detected
        if {$nucleotide ni {{A} {C} {G} {T}}} {
            return -code error "Invalid nucleotide in strand"
        }

        # Otherwise increment the value's count
        incr counts($nucleotide)
    }

    # Return array values as a dictionary-formatted list
    return [lsort -stride 2 -index 0 [array get counts]]
}
