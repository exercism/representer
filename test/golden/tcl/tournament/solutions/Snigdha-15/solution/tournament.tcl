proc cmp {a b} {
  set x [dict get $a P]
  set y [dict get $b P]
  set z [expr {$y - $x}]
  return [expr {$z == 0 ? [string compare [dict get $a team] [dict get $b team]] : $z}]
}

proc tournamentResults {filename} {
    set lines {}
    set db [dict create]
    proc updt {x w l d} {
        upvar db m
        puts "updt $x $w $l $d"
        dict update m $x rec {
            dict incr rec W  $w
            dict incr rec L  $l
            dict incr rec MP 1
            dict incr rec D  $d
            dict incr rec P  [expr $w ? 3 : $l ? 0 : 1]
        }
    }
    set teams [dict create]

    set f [open $filename "r"]; while {0 <= [gets $f x]} {
        if {0 == [string length $x]} { continue }
        lappend lines [split $x ";"]
    };  close $f
    puts $lines
    foreach x $lines {
        set a [lindex $x 0]
        set b [lindex $x 1]
        set c [lindex $x 2]
        dict append teams $a 1
        dict append teams $b 1
        if {$c == "win" } { updt $a 1 0 0; updt $b 0 1 0}
        if {$c == "loss"} { updt $a 0 1 0; updt $b 1 0 0}
        if {$c == "draw"} { updt $a 0 0 1; updt $b 0 0 1}
    }
    puts "db $db"

    set y {}
    lappend y [format "%-31s| MP |  W |  D |  L |  P" "Team"]
    puts [dict key $teams]
    foreach x [lsort -command cmp [dict values [dict map {k v} $db { dict set v team $k }]]] {
        lappend y [format "%-31s| %2d | %2d | %2d | %2d | %2d" \
            [dict get $x team] \
            [dict get $x MP] \
            [dict get $x W] \
            [dict get $x D] \
            [dict get $x L] \
            [dict get $x P]
        ]
    }
    return [join $y "\n"]
}

