proc addGigasecond {datetime} {
    set givenDatetime [clock scan $datetime -timezone :UTC]
    set gigasecond [expr {int(pow(10,9))}];
    return [clock format [ expr {$gigasecond + $givenDatetime} ] -format "%Y-%m-%dU%H:%M:%S" -timezone :UTC]
}
