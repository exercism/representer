source "tree.tcl"

oo::class create Zipper {
    variable focus context

    constructor {aTree {ctx {}}} {
        set focus $aTree
        set context $ctx
    }

    method tree {} {
        if {[llength $context] == 0} {
            set focus
        } else {
            tailcall [[self object] up] tree
        }
    }

    method value {} { $focus value }
    method setValue {x} { $focus setValue $x }
    method setLeft {t} { $focus setLeft $t }
    method setRight {t} { $focus setRight $t }

    method up {} {
        if {[llength $context] == 0} {
            return ""
        } else {
            lassign [lindex $context 0] left value right
            set tree [Tree new [dict create value $value]]
            if {$left eq "null"} {
                $tree setLeft $focus
                $tree setRight $right
            } else {
                $tree setLeft $left
                $tree setRight $focus
            }
            [self class] new $tree [lrange $context 1 end]
        }
    }

    method left {} {
        if {[$focus left] eq {}} {
            return ""
        }
        set newCtx [list null [$focus value] [$focus right]]
        [self class] new [$focus left] [concat [list $newCtx] $context]
    }

    method right {} {
        if {[$focus right] eq {}} {
            return ""
        }
        set newCtx [list [$focus left] [$focus value] null]
        [self class] new [$focus right] [concat [list $newCtx] $context]
    }

    method equals {other} {
        [my tree] equals [$other tree]
    }
}
