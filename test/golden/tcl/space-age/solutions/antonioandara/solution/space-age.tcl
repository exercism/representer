array set periods {
    Mercury 0.2408467
    Venus 0.61519726
    Earth 1.0
    Mars 1.8808158
    Jupiter 11.862615
    Saturn 29.447498
    Uranus 84.016846
    Neptune 164.79132
}

rename unknown _original_unknown
proc unknown {args} {
    set cmd [lindex $args 0]

    if {[info proc $cmd] != ""} {
        return [uplevel [list _original_unknown $args]]
    } else {
        error "not a planet"
    }
}

proc age_on {planet seconds} {
    global periods periods
    set earth_seconds_per_year 31557600.0

    set earth_years [expr {double($seconds) / $earth_seconds_per_year}]
    set age [expr {$earth_years / double($periods($planet))}]
    
    return $age
}

foreach planet [array names periods] {
    proc "on$planet" {time} "return \"\[age_on $planet \$time\]\""
}