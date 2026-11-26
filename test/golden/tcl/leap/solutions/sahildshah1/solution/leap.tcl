#!/usr/bin/env tclsh

proc isLeapYear {year} {

    set leapyear 0

    if {($year % 4 == 0) & ($year % 100 != 0 | $year % 400 == 0 )} {

        set leapyear 1

    }

    return $leapyear    



}
