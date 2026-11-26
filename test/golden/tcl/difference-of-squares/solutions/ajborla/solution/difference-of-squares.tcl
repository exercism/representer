#!/usr/bin/env tclsh

# ----------------------------------------------------------------------------
# exercism.org
# Tcl Track Exercise: difference-of-squares
# Contributed: Anthony J. Borla (ajborla@bigpond.com)
# ----------------------------------------------------------------------------

proc squareOfSum {n} {
    return [expr {($n * ($n + 1) / 2) ** 2}]
}

proc sumOfSquares {n} {
    return [expr {$n * ($n + 1) * (2 * $n + 1) / 6}]
}

proc differenceOfSquares {n} {
    return [expr {[squareOfSum $n] - [sumOfSquares $n]}]
}
