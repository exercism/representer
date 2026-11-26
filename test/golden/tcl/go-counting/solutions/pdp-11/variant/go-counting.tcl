oo::class create GoBoard {
	variable board rows cols
    constructor {input} {
        set board [lmap row $input {split $row {}}]
		set rows [llength $board]
		set cols [llength [lindex $board 0]]
    }

    method territory {intersection} {
		set queue [list $intersection]
		set territory [list]
		set borderColor {}
		array set visited {}

		lassign $intersection cx cy
		if {![my InBoard $cx $cy]} {
			error "Invalid coordinate"
		}
		set color [my GetPoint $cx $cy]
		if {$color eq "none"} {
			set visited($cx,$cy) 1
		} else {
			return [list none $territory]
		}

		while {[llength $queue] > 0} {
			lassign [lindex $queue 0] cx cy
			set queue [lreplace $queue 0 0]
			lappend territory [list $cx $cy]

			foreach {dx dy} {0 1  1 0  0 -1  -1 0} {
				set nx [expr {$cx + $dx}]
				set ny [expr {$cy + $dy}]

				if {![my InBoard $nx $ny]} continue
				set color [my GetPoint $nx $ny]
				if {$color eq "none" } {
					if {[info exists visited($nx,$ny)]} continue
					set visited($nx,$ny) 1
					lappend queue [list $nx $ny]
				} elseif {$color ne $borderColor} {
					if {$borderColor eq {}} {
						set borderColor $color
					} else {set borderColor "none"}
				}
			}
		}
		# boundary condition: 1x1 board with no peices.
		if {$borderColor eq {}} {set borderColor "nooe"}
		list $borderColor [lsort $territory]
    }

    method territories {} {
        array set visited {}
		lassign {{} {} {}} black white none

		for {set x 0} {$x < $cols} {incr x} {
			for {set y 0} {$y < $rows} {incr y} {
				if {[info exists visited($x,$y)]} continue
				set visited($x,$y) 1
				lassign [my territory [list $x $y]] color territory
				foreach p $territory {
					lassign $p px py
					if {[info exists visited($px,$py)]} continue
					set visited($px,$py) 1
				}
				lappend $color {*}$territory
			}
		}

		set res [dict create]
		foreach color {none white black} {
			dict set res $color [lsort [set $color]]
		}
		set res
    }

	method GetPoint {x y} {
		set p [lindex $board $y $x]
		switch -- $p {
			"B" {return black}
			"W" {return white}
			" " {return none }
			default {error "unknow ($x, $y): $p"}
		}
	}
	method InBoard {x y} {
		expr {$x >= 0 && $x < $cols && $y >= 0 && $y < $rows}
	}
}
