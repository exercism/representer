oo::class create Node {
    variable datum
    variable next

    constructor {value} {
        set datum $value
        set next {}
    }

    method datum {} {return $datum}

    method next {{node ""}} {
        if {[info object isa typeof $node [self class]]} {
            set next $node
        } elseif {$node eq "<NULL>"} {
            set next ""
        }
        return $next
    }
}

oo::class create SimpleLinkedList {
    # implement push/pop from head (shift/unshift)
    variable head

    constructor {{values {}}} {
        set head {}
        foreach value $values {
            set node [Node new $value]
            my push $node
        }
    }

    method push {node} {
        if {$head ne ""} {
            $node next $head
        }
        set head $node
        return [self]
    }

    method pop {} {
        set current $head
        if {$current ne ""} {
            set head [$current next]
            $current next <NULL>
        }
        return $current
    }

    method toList {} {
        set output [list]
        set current $head
        while {$current ne ""} {
            lappend output [$current datum]
            set current [$current next]
        }
        return $output
    }

    method length {} {
        set current $head
        set length 0
        while {$current ne ""} {
            set current [$current next]
            incr length
        }
        return $length
    }

    method reverse {} {
        if {$head eq {}} {return [self]}
        set length [my length]
        set node $head
        set next {}
        set prev <NULL>
        for {set i 0} {$i < $length} {incr i} {
            set next [$node next]
            $node next $prev
            set prev $node
            set node $next
        }
        set head $prev
        return [self]
    }

    method foreach {varname script} {
        upvar 1 $varname var
        set var $head
        while {$var ne ""} {
            uplevel 1 $script
            set var [$var next]
        }
    }
}
