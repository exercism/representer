namespace eval resistorColor {
    #Usando un diccionario
    #variable colors
    set  colors [dict create {*}{
	black 0
	brown 1
	red 2
	orange 3
	yellow 4
	green 5
	blue 6
	violet 7
	grey 8
	white 9
    }]

#puts $colors
    proc colors {} {
	variable colors
 	return [dict keys $colors]
    }

   proc colorCode {color} {
       variable colors
       set color [string tolower $color]
       if {[dict exists $colors $color]} {
	   return [dict get $colors $color]
       } else {
	   error "Invalid color: $color"
       }
   }
}
