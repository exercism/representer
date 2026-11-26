Function Get-SquareRoot() {
    <#
    .SYNOPSIS
    Given a natural radicand, return its square root.
    
    .DESCRIPTION
    The function takes a positive integer and return its square root value.

    .PARAMETER Radicand
    The number to get its square root.
    
    .EXAMPLE
    Get-SquareRoot -Radicand 25
    Retuns: 5
    #>
    [CmdletBinding()]
    Param(
        [int]$Radicand
    )
    
    # I mean we'd normally just do this:
    # return [math]::Sqrt($Radicand)

    # But let's do it the hard way:
    $Guess = 1
    while ($Guess * $Guess -ne $Radicand) {
        $Guess = ($Guess + ($Radicand / $Guess)) / 2
    }

    return $Guess
}