#! tclsh

oo::class create HighScores {

    constructor {} {
        my variable scores_
        set scores_ {}
    }
    method addScores {args} {
        my variable scores_
        lappend scores_ {*}$args
    }
    method scores {} {
        my variable scores_
        return $scores_
    }
    method latest {} {
        my variable scores_
        lindex $scores_ end
    }
    method personalBest {} {
        my variable scores_
        if {[llength $scores_] == 0} {
            return {}
        } else {
            tcl::mathfunc::max {*}$scores_
        }
    }
    method topThree {} {
        my variable scores_
        lrange [lsort -decreasing -integer $scores_] 0 2
    }
}
