Function Get-GrainSquare() {
    <#
    .SYNOPSIS
    Get the number of grains on a square.

    .DESCRIPTION
    Given a number, return the number of grains on that square.
    
    .PARAMETER Number
    Which square to get the number of grains.
    
    .EXAMPLE
    Get-GrainSquare -Number 2
    #>
    [CmdletBinding()]
    Param(
        [BigInt]$Number
    )

    if ($Number -gt 64 -or $Number -lt 1) {
        throw "square must be between 1 and 64"
    }

    return [BigInt]::Pow(2, $Number-1)
}

Function Get-GrainTotal() {
    <#
    .SYNOPSIS
    Get the total number of grains.

    .DESCRIPTION
    Return the total number of grains on the board.

    .EXAMPLE
    Get-GrainTotal
    #>

    $total = 0
    for ($i = 1; $i -lt 65; $i++) {
        $total += Get-GrainSquare -Number $i
    }

    $total

}
