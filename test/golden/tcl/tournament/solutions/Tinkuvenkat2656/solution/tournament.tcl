proc tournamentResults { filename } {
    lassign [list] table played wins draws losses

    set _file [open $filename r]
    while { [gets $_file line] > 0 } {
        lassign [split $line ";"] home_team away_team result

        dict incr played $home_team
        dict incr played $away_team
        if { $result eq "win" } {
            dict incr wins $home_team
            dict incr losses $away_team
        } elseif { $result eq "loss" } {
            dict incr wins $away_team
            dict incr losses $home_team
        } elseif { $result eq "draw" } {
            dict incr draws $away_team
            dict incr draws $home_team
        }
    }
    close $_file

    set stats [list]
    dict for { team match_played } $played {
        set w [dict getdef $wins $team 0]
        set d [dict getdef $draws $team 0]

        lappend stats \
            $team \
            $match_played \
            $w \
            $d \
            [dict getdef $losses $team 0] \
            [expr { $w * 3 + $d }]
    }

    set stats [lsort -stride 6 -index 5 -integer -decreasing \
        [lsort -stride 6 -index 0 -increasing $stats] \
    ]

    return [printTable $stats]
}

proc printTable { stats } {
    set pattern "%-30s | %2s | %2s | %2s | %2s | %2s"
    set formatted_table [format $pattern Team MP W D L P]

    foreach { team mp w d l p } $stats {
        append formatted_table "\n" [format $pattern $team $mp $w $d $l $p]
    }
    return $formatted_table
}