Function Get-ResistorLabel() {
    <#
    .SYNOPSIS
    Implement a function to get the label of a resistor with three color-coded bands.

    .DESCRIPTION
    Given an array of colors from a resistor, decode their resistance values and return a string represent the resistor's label.

    .PARAMETER Colors
    The array repesent the 3 colors from left to right.

    .EXAMPLE
    Get-ResistorLabel -Colors @("red", "white", "blue")
    Return: "29 megaohms"
     #>
    [CmdletBinding()]
    Param(
        [string[]]$Colors
    )
    $Colorcodes = @{
    black = 0; brown = 1; red =2; orange = 3; yellow = 4; green = 5; blue = 6; violet = 7; grey = 8; white = 9
    }
    $Kombi = @()
    $max = $Kombi.Count
    foreach ($Farbe in $Colors) {
        $Kombi += $Colorcodes[$Farbe]         
    }
    $Duo = "$($Kombi[0])$($Kombi[1])"
    $unit = "ohms"
    if ($Kombi.Count -gt 2) {
        $Duo += '0' / $Kombi[2]
        $Duo = [int64]$Duo
        if ($Duo -gt 999999999) {
            $unit = "gigaohms"
            $Duo = [math]::Round($Duo / 1000000000, 2)
        } elseif ($Duo -gt 999999) {
            $unit = "megaohms"
            $Duo = [math]::Round($Duo / 1000000, 2) 
            } elseif ($Duo -gt 999) {
            $unit = "kiloohms"
            $Duo = [math]::Round($Duo / 1000, 2)
        }
    }

    Write-Output "$Duo $unit"
}
