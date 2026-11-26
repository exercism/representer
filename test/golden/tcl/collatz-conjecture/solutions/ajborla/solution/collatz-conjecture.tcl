#!/usr/bin/env tclsh

# ----------------------------------------------------------------------------
# exercism.org
# Tcl Track Exercise: collatz-conjecture
# Contributed: Anthony J. Borla (ajborla@bigpond.com)
# ----------------------------------------------------------------------------

proc steps {n} {
    # Conjecture applies to positive integers only
    if {$n < 1} { return -code error "Only positive integers are allowed" }

    # Base case terminating the recursion
    if {$n == 1} { return 0 }

    # If `n` is even ... 
    if {[expr $n % 2 == 0]} { return [expr 1 + [steps [expr $n / 2]]] }

    # ... otherwise do this
    return [expr 1 + [steps [expr $n * 3 + 1]]]
}
