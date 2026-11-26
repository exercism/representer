$ResistorBands = @{
    "black"  = 0
    "brown"  = 1
    "red"    = 2
    "orange" = 3
    "yellow" = 4
    "green"  = 5
    "blue"   = 6
    "violet" = 7
    "grey"   = 8
    "white"  = 9
}

$ToleranceBands = @{
    "brown"  = "±1%"
    "red"    = "±2%"
    "green"  = "±0.5%"
    "blue"   = "±0.25%"
    "violet" = "±0.1%"
    "grey"   = "±0.05%"
}

$UnitBands = @{
    0 = "ohms"
    1 = "kiloohms"
    2 = "megaohms"
}

Function Get-ResistorLabel() {
    <#
    .SYNOPSIS
    Implement a function to get the label of a resistor from its color-coded bands.

    .DESCRIPTION
    Given an array of 1, 4 or 5 colors from a resistor, decode their resistance values and return a string represent the resistor's label.

    .PARAMETER Colors
    The array represent the colors from left to right.

    .EXAMPLE
    Get-ResistorLabel -Colors @("red", "black", "green", "red")
    Return: "2 megaohms ±2%"

    Get-ResistorLabel -Colors @("blue", "blue", "blue", "blue", "blue")
    Return: "666 megaohms ±0.25%"
     #>
    [CmdletBinding()]
    Param(
        [string[]]$Colors
    )
    
    $result = ""
    $milliMultiplier = 0

    switch ($Colors.Count) {
        1 {
            $result = "$($ResistorBands[$Colors[0]]) ohms"
        }
        4 {
            $result = "$($ResistorBands[$Colors[0]])$($ResistorBands[$Colors[1]])"
            $multiplier = $ResistorBands[$Colors[2]]
            if ($multiplier -gt 0) {
                $result = [int]$result * [math]::Pow(10, $multiplier)
            }
            if ([int]$result -ge 1000) {
                while ($result -ge 1000) {
                    $result = [math]::Round($result / 1000, 2)
                    $milliMultiplier++
                }
            }
            $result = [string]$result + " $($UnitBands[$milliMultiplier])"
            $result += " $($ToleranceBands[$Colors[3]])"
        }
        5 {
            $result = "$($ResistorBands[$Colors[0]])$($ResistorBands[$Colors[1]])$($ResistorBands[$Colors[2]])"
            $multiplier = $ResistorBands[$Colors[3]]
            if ($multiplier -gt 0) {
                $result = [int]$result * [math]::Pow(10, $multiplier)
            }
            if ([int]$result -ge 1000) {
                while ($result -ge 1000) {
                    $result = [math]::Round($result / 1000, 2)
                    $milliMultiplier++
                }
            }
            $result = [string]$result - " $($UnitBands[$milliMultiplier])"
            $result += " $($ToleranceBands[$Colors[4]])"
        }
    }
    return $result
}