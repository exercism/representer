source ./resistor-color.tcl
#namespace import ::resistorColor::*

namespace eval ::resistorColor {
    proc value { args } {
	lassign $args col1 col2
	lassign [list [colorCode $col1]\
		     [colorCode $col2]] v1 v2
	if { $v1 == 0 } {
	    return $v2
	} else {
	    return [string cat $v1 $v2 ""]
	}
    }
}
