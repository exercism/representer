
set students {}

proc school {args} {
    global students
    lassign $args method_name ls
    switch $method_name {
        add {
            set acc {}
            foreach new_s $ls {
                set exists 0
                foreach old_s $students {
                    if {[lindex $new_s 0] eq [lindex $old_s 0]} {
                        set exists 1
                    }
                }
                if {!$exists} {
                    lappend students $new_s
                    lappend acc true
                } else {
                    lappend acc false
                }
            }
            return $acc
        }
        reset {
            set students {}
        }
        grade {
            if {![llength $students]} {
                return ""
            }
            set g $ls
            return [lsort [lmap x $students {
                    if {[expr { [lindex $x 1] eq $g }]} {
                        expr {[lindex $x 0]}
                    } else {
                        continue
                    }
                }]
            ]
        }
        roster {
            set sorted_stus [lsort -integer -index 1 [lsort -index 0 $students]]
            return [lmap x $sorted_stus { expr {[lindex $x 0]} } ]
        }
    }
}
