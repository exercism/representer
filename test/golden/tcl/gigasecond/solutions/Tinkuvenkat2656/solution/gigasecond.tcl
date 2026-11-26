proc addGigasecond {datetime} {
    set fmt {%Y-%m-%dT%H:%M:%S}
    set time [clock add \
        [clock scan $datetime -timezone :UTC] \
        1000000000 seconds
    ]
    return [clock format $time -timezone :UTC -format $fmt]
}