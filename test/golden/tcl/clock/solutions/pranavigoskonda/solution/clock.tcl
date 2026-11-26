oo::class create Clock {
    variable minsSinceMidnight

    constructor {hour minute} {
        set minsSinceMidnight 0
        my add [expr {$hour * 60 + $minute}]
    }

    method toString {} {
        set hour [expr {$minsSinceMidnight / 60}]
        set minute [expr {$minsSinceMidnight % 60}]
        format "%02d:%02d" $hour $minute
    }

    method add {minutes} {
        set minutesPerDay 1440
        set minsSinceMidnight [expr {($minsSinceMidnight + $minutes) % $minutesPerDay}]
        self
    }

    method minutesSinceMidnight {} {
        expr {$minsSinceMidnight}
    }

    method subtract {minutes} {
        my add [expr {0 - $minutes}]
    }

    method equals {other} {
        expr {[my minutesSinceMidnight] == [$other minutesSinceMidnight]}
    }

    forward == my equals
    export ==
}