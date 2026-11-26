<#
.SYNOPSIS
    Implement a clock that handles times without dates.

.DESCRIPTION
    Implement a clock that handles times without dates in 24 hours format.
    You should be able to add and subtract minutes to it.
    Two clocks that represent the same time should be equal to each other.
    Note: Please try to implement the class and its method instead of using built-in module Datetime.

.EXAMPLE
    $clock1 = [Clock]::new(5,0)
    $clock1.ToString()
    Return: "05:00"

    $clock2 = [Clock]::new(6,-120)
    $clock2.Add(60).ToString()
    Return: "05:00"

    $clock1 -eq $clock2
    Return: $true
#>

class Clock {
    [INT64]$TotalMinutes
    [int]$Hours
    [int]$Minutes

    Clock([int32]$hr, [int32]$mn) {
        $this.ConvertMinutesToHourAndMinute( ([int64]($mn + $hr*60)) )
    }

    [string] ToString() {
        return ("{0:d2}:{1:d2}" -f $this.Hours, $this.Minutes)
    }
    [Clock] Add([int32]$m){
        $this.TotalMinutes += $m
        $this.ConvertMinutesToHourAndMinute($this.TotalMinutes)
        return $this
    }
    [bool] Equals($Clock) {
        $c1 = $this.TotalMinutes
        $c2 = [int64]$Clock.TotalMinutes
        return ($c1 -eq $c2)
    }
    [void] ConvertMinutesToHourAndMinute([int64]$mins){
        $hrs = [int64][Math]::Floor( ($mins / 60) )          # get the whole number of hours
        $hr  = [int64]($hrs % 24)                            # get just the hour within 0 to 23
        $mns = [int64][Math]::Abs($mins - $hrs * 60)         # get the number of minutes
        if ($hr -lt 0){                                      # adjust negative hours to be within 0 - 23
            $hr = $hr + 24
        }
        $this.TotalMinutes = $hr*60 + $mns
        $this.Hours = $hr
        $this.Minutes = $mns

    }
}