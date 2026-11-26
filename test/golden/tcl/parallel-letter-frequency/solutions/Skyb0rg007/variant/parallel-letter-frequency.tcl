package require Thread

proc calculate {input} {
    tsv::set calculate counts {}
    set tids {}

    set worker {{line} {
        set localCounts {}
        foreach c [split [string tolower $line] ""] {
            if {[string is alpha $c]} {
                dict incr localCounts $c
            }
        }
        tsv::lock calculate {
            set counts [tsv::get calculate counts]
            dict for {c n} $localCounts {
                dict incr counts $c $n
            }
            tsv::set calculate counts $counts
        }
    }}

    foreach line $input {
        lappend tids [thread::create -joinable [list apply $worker $line]]
    }
    foreach tid $tids {
        thread::join $tid
    }

    set res [tsv::pop calculate counts]
    puts "rfs: $res"
    set res
}
