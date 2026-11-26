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

    [int]$Hours
    [int]$Minutes

    Clock([int]$hours, [int]$minutes) {

        $inputHours = $hours
        $inputMinutes = $minutes

        # Normalize negatives
        while ($inputHours -lt 0) {
            $inputHours += 24
        }        
        while ($inputMinutes -lt 0) {
            $inputMinutes += 60
            $inputHours--
        }

        # Handle hour underflow
        while ($inputHours -lt 0) {
            $inputHours += 24
        }        

        # Overflow
        $totalMinutes = ($inputHours * 60 + $inputMinutes) % (24 * 60) 
        $this.Hours = [math]::Floor($totalMinutes / 60)
        $this.Minutes = $totalMinutes % 60
    }

    [string]ToString() {
        return "{0:D2}:{1:D2}" -f $this.Hours, $this.Minutes
    }

    [Clock]Add([int]$minutesToAdd) {
        $minusCompensation = 0
        if ($minutesToAdd -lt 0) {
            $daysToSubtract = [math]::Floor($minutesToAdd / (24 * 60))
            $minutesToAdd += $daysToSubtract * (24 * 60)
            $minusCompensation += 1
        }        
        $totalMinutes = ($this.Hours * 60 + $this.Minutes + $minutesToAdd) % (24 * 60)
        return [Clock]::new([math]::Floor($totalMinutes / 60) + $minusCompensation, $totalMinutes % 60)
    }

    [bool]Equals([object]$other) {
        if ($other -is [Clock]) { 
            return ($this.Hours -eq $other.Hours) -and ($this.Minutes -eq $other.Minutes)
        }
        return $false
    }

}
