function Test-LeapYear {
    param( [int]$year )

    return !($year % 4) -and (($year % 100) -or !($year % 400))
}