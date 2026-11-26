oo::class create Robot {
	variable x y direction
    constructor {{inputd {}}} {
		set inputd [dict merge {x 0 y 0 direction north} $inputd]
		dict with inputd {
			if {$direction ni {north south east west}} {error "invalid direction"}
			if {![string is integer $x]} {error "invalid x coordinate"}
			if {![string is integer $y]} {error "invalid y coordinate"}
		}
		dict for {k v} $inputd {set $k $v}
    }

	method position {} {
		dict create x $x y $y direction $direction
	}

	method move {input} {
		foreach c [split $input {}] {
			switch -- $c {
				A {my Advance}
				L {my Rotate left}
				R {my Rotate right}
				default {error "invalid instruction: $c"}
			}
		}
	}

	method Advance {} {
		switch -- $direction {
			south {incr y -1}
			north {incr y 1}
			east  {incr x 1}
			west  {incr x -1}
			default {error "why yov here?"}
		}
	}
	method Rotate {how} {
		switch -- $direction {
			south {set direction [expr {$how eq "left" ? "east" : "west"}]}
			north {set direction [expr {$how eq "left" ? "west" : "east"}]}
			east  {set direction [expr {$how eq "left" ? "north" : "south"}]}
			west  {set direction [expr {$how eq "left" ? "south" : "north"}]}
			default {error "why you here?"}
		}
	}
}
