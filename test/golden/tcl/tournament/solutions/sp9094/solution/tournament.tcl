proc compare {a b} {
    set a5 [lindex $a 5]
    set b5 [lindex $b 5]
    if {$a5 < $b5} {
        return -1
    } elseif { $a5 > $b5 } {
        return 1
    }
    return [string compare [lindex $b 0] [lindex $a 0]]
}

proc initializeTeam {scoresVar team} {
    upvar $scoresVar scoresDict
    if ![dict exists $scoresDict $team] then {
        dict set scoresDict $team {MP 0 W 0 D 0 L 0 P 0 }
    }
}

proc updateScores {scoresVar team result} {
    upvar $scoresVar scoresDict
    dict update scoresDict $team info {
        dict incr info MP
        switch $result {
            win {
                dict incr info W
                dict incr info P 3
            }
            loss {
                dict incr info L
            }
            draw {
                dict incr info D
                dict incr info P
            }
        }
    }
}


proc tournamentResults {filename} {
    #the header
    set fmt "%-31s| %2s |%3s |%3s |%3s |%3s"
    set header [format $fmt Team MP W D L P]
    #for the file
    set scores [dict create]
    set fileId [open $filename r]
    array set secondResult {win loss loss win draw draw}
   
    while {[set c [gets $fileId line]] >= 0} {
        set fields [split $line ";"]
        if {[llength $fields] != 3} then continue
        lassign $fields team1 team2 result1
        #set result2 [secondResult $result1]
        set result2 $secondResult($result1)

        foreach t [list $team1 $team2] {
            initializeTeam scores $t
        }
  
        foreach {t r} [list $team1 $result1 $team2 $result2] {
            #puts "$t, $r"
            updateScores scores $t $r
        }
    };#end of while

    close $fileId
    set toOrder ""
    set res ""

    dict for {id info} $scores {
        dict with info {
            lappend toOrder  [list $id $MP $W $D $L $P]
        }
    }
    
    set toOrder [lsort -decreasing -command compare $toOrder]

    foreach a $toOrder {
        lappend res [format $fmt {*}$a ]
    }
        return  [join [concat [list $header] $res] \n]
}