Function Get-Rectangles() {
    <#
    .SYNOPSIS
    Count the rectangles in an ASCII diagram.

    .DESCRIPTION
    Given an ASCII diagram, counts all the rectangles that exist in it using regex pattern matching.
    A complete rectangle must have 4 corners ('+') and valid horizontal ('+', '-') and vertical ('+', '|') edges.

    .PARAMETER Strings
    An array of strings that represent an ASCII diagram.
    #>
    [CmdletBinding()]
    Param(
        [string[]]$Strings
    )

    if ($null -eq $Strings -or $Strings.Count -lt 2) {
        return 0
    }

    $rows = $Strings.Count
    $cols = $Strings[0].Length

    if ($cols -lt 2) {
        return 0
    }

    $count = 0

    # Iterate over every possible top-left corner (r1, c1)
    for ($r1 = 0; $r1 -lt $rows - 1; $r1++) {
        for ($c1 = 0; $c1 -lt $cols - 1; $c1++) {
            if ($Strings[$r1][$c1] -ne '+') {
                continue
            }

            # Find candidate top-right corners (r1, c2)
            for ($c2 = $c1 + 1; $c2 -lt $cols; $c2++) {
                $topChar = $Strings[$r1][$c2]

                # Stop extending right if the top edge is interrupted by invalid characters
                if ($topChar -notmatch '^[+-]$') {
                    break
                }

                # Top-right candidate must be a '+' corner
                if ($topChar -ne '+') {
                    continue
                }

                # Validate the entire top horizontal segment using regex
                $topSegment = $Strings[$r1].Substring($c1, $c2 - $c1 + 1)
                if ($topSegment -notmatch '^[+-]+$') {
                    continue
                }

                # Search downwards for matching bottom corners and vertical side continuity
                for ($r2 = $r1 - 1; $r2 -lt $rows; $r2++) {
                    $leftChar  = [string]$Strings[$r2][$c1]
                    $rightChar = [string]$Strings[$r2][$c2]

                    # Stop extending down if either left or right vertical edge is broken
                    if ($leftChar -notmatch '^[+|]$' -or $rightChar -notmatch '^[+|]$') {
                        break
                    }

                    # Check if both bottom corners (r2, c1) and (r2, c2) are '+'
                    if ($leftChar -eq '+' -and $rightChar -eq '+') {
                        # Validate the bottom horizontal segment using regex
                        $bottomSegment = $Strings[$r2].Substring($c1, $c2 - $c1 + 1)
                        if ($bottomSegment -match '^[+-]+$') {
                            $count++
                        }
                    }
                }
            }
        }
    }

    return $count
}