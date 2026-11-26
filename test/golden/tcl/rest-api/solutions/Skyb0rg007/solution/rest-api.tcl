oo::class create RestAPI {
    variable users

    constructor {data} {
        set users {}
        foreach user [dict get $data users] {
            dict set users [dict get $user name] $user
        }
    }

    method get {path {payload {}}} {
        if {$path eq "/users"} {
            if {$payload eq {}} {
                return [dict create users [dict values $users]]
            } else {
                set query [dict get $payload users]
                set users [lmap name $query {dict get $users $name}]
                set users [lsort -index 1 $users]
                return [dict create users $users]
            }
        } else {
            return -code error "Invalid path $path"
        }
    }

    method post {path payload} {
        if {$path eq "/add"} {
            set name [dict get $payload user]
            set user [dict create name $name owes {} owed_by {} balance 0]
            dict set users $name $user
            return $user
        } elseif {$path eq "/iou"} {
            set lenderName [dict get $payload lender]
            set borrowerName [dict get $payload borrower]
            set amount [dict get $payload amount]
            dict update users $lenderName lender $borrowerName borrower {
                dict update lender owes owes owed_by owed_by balance balance {
                    if {[dict exists $owes $borrowerName]} {
                        set newBal [expr {[dict get $owes $borrowerName] - $amount}]
                        if {$newBal > 0} {
                            dict set owes $borrowerName $newBal
                        } else {
                            set owes [dict remove $owes $borrowerName]
                            if {$newBal < 0} {
                                dict incr owed_by $borrowerName [expr { -$newBal }]
                            }
                        }
                    } else {
                        dict incr owed_by $borrowerName $amount
                    }
                    set owed_by [lsort -stride 2 $owed_by]
                    set owes [lsort -stride 2 $owes]
                    incr balance $amount
                }
                dict update borrower owes owes owed_by owed_by balance balance {
                    if {[dict exists $owed_by $lenderName]} {
                        set newBal [expr {[dict get $owed_by $lenderName] - $amount}]
                        if {$newBal > 0} {
                            dict set owed_by $lenderName $newBal
                        } else {
                            set owed_by [dict remove $owed_by $lenderName]
                            if {$newBal < 0} {
                                dict incr owes $lenderName [expr { -$newBal }]
                            }
                        }
                    } else {
                        dict incr owes $lenderName $amount
                    }
                    set owed_by [lsort -stride 2 $owed_by]
                    set owes [lsort -stride 2 $owes]
                    incr balance -$amount
                }
            }
            my get "/users" [dict create users [list $lenderName $borrowerName]]
        } else {
            return -code error Unimplemented
            
        }
    }
}
