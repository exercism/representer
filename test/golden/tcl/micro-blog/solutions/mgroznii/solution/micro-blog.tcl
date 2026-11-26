package require Tcl 9.0

proc truncate {input} {
    eval {string range $input 0 4 }
}
