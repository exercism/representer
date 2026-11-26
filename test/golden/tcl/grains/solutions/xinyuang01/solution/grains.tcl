namespace eval grains {
    namespace export square total

    # This turns the namespace name "grains" into
    # the _command_ "grains", with subcommands
    # "square" and "total":
    namespace ensemble create

    proc square {square} {
        if {$square < 1} {
            throw 1 "square must be between 1 and 64"
        }
        if {$square > 64} {
            throw 1 "square must be between 1 and 64" 
        }
        return [expr 2**[expr $square-1]]
    }

    proc total {} {
        return [expr 2**64-1]
    }
}
