proc sublist {list1 list2} {
    #equal lists
    set both [string equal $list1 $list2]
    if {$both == 1} {return "equal"}
    
    #Testing Edge case of empty list
    if {[llength $list1] == 0} {
        return "sublist"
    }
    if {[llength $list2] == 0} {
        return "superlist"
    }

    #testing for super/sub
    if {[llength $list1] < [llength $list2]} {
        #list1 in list2
        set left [string first $list1 $list2]
        #Sanitation check
        if {$left != -1} {
            #Compare last elements for truncation
            set checki [expr {$left + [string length $list1] - 1}]
            if {[lindex $list1 end] == [string index $list2 $checki]} {
                return "sublist"
            }
        }
    } else {
        #list2 in list1
        set right [string first $list2 $list1]
        if {$right != -1} {
            #Compare last elements for truncation
            set checki [expr {$right + [string length $list2] - 1}]
            if {[lindex $list2 end] == [string index $list1 $checki]} {
                return "superlist"
            }        
        }    
    }
    
    #No matches
    return "unequal"
}
