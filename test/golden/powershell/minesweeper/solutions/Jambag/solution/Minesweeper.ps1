Function Get-Annotate() {
    <#
    .SYNOPSIS
    Add the mine counts to a completed Minesweeper board.

    .DESCRIPTION
    Minesweeper is a popular game where the user has to find the mines using numeric hints that indicate how many mines are directly adjacent (horizontally, vertically, diagonally) to a square.

    In this exercise you have to create some code that counts the number of mines adjacent to a given empty square and replaces that square with the count.

    The board is a rectangle composed of blank space (' ') characters.
    A mine is represented by an asterisk (`*`) character.

    If a given space has no adjacent mines at all, leave that square blank.

    .PARAMETER Minefield
    An array of string, each represent a row of the minefield.
    This parameter should be validated to check that only blank space and asterisk are in it.

    .EXAMPLE
    Get-Annotate -Minefield @(" *** ")
    Returns: @("1***1")
    #>
    [CmdletBinding()]
    Param(
        [string[]]$Minefield
    )

    # check for strange characters
    if ($Minefield -replace '[ *]' -ne '') {
        throw "Error: allowed characters are ' ' and '*'"
    }

    # Converts Minefield into array of arrays, with '0' instead of ' '
    $mfNumbers = @()
    foreach ($row in $Minefield) {
        $mfNumbers += ,($row -replace ' ','0' -split '(.)' -ne '')
    }

    # Max limits (row/column)
    $maxR = $Minefield.Count - 1
    $MaxC = $Minefield[0].Length - 1

    # Search for '*'
    for ($i = 0; $i -le $maxR; $i++) {
        for ($j = 0; $j -le $maxC; $j++) {

            # If it's a '*'
            if ($mfNumbers[$i][$j] -eq '*') {

                # Add 1 to surrounding non '*'
                for ($i2 = [Math]::Max(0, $i - 1); $i2 -le [Math]::Min($maxR, $i + 1); $i2++) {
                    for ($j2 = [Math]::Max(0, $j - 1); $j2 -le [Math]::Min($maxC, $j + 1); $j2++) {
                        if ($mfNumbers[$i2][$j2] -ne '*') {
                            ([int]$mfNumbers[$i2][$j2])++
                        }
                    }
                }
            }
        }
    }

    # Converts to array of string rows ('0' to ' ')
    $mfNumbers | Foreach-Object { (-join $_) -replace '0', ' '}
}
