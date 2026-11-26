Function Get-ColorCodeValue() {
    [CmdletBinding()]
    Param(
        [string[]]$Colors
    )
    

    $ColourValues = @("black", "brown", "red", "orange", "yellow", "green", "blue", "violet", "grey", "white")

    $Value1 = [Array]::IndexOf($ColourValues, $Colors[0]) * 10
    $Value2 = [Array]::IndexOf($ColourValues, $Colors[1])
    $ColourCode = $Value1 +$Value2
    

    return [int]$ColourCode

    }

