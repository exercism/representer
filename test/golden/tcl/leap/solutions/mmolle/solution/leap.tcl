#!/usr/bin/env tclsh

proc isLeapYear {year} {
    if {$year % 400 == 0} {
        return 1
    } elseif { $year % 100 == 0 } {
        return 0
    } elseif { $year % 4 == 0 } {
        return 1
    } else {
        return 0
    }
}
