proc recite {items} {
    set output [list]

     if {[llength $items] == 0} {return $output}
     
    for {set i 0} {$i < [expr {[llength $items] - 1}]} {incr i} {
        lappend output "For want of a [lindex $items $i] the [lindex $items [expr $i+1]] was lost."
    }
    
    lappend output "And all for the want of a [lindex $items 0]."
    
    return $output
}
