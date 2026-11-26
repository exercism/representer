<#
.SYNOPSIS
    Implement a program to find word in a search puzzle.

.DESCRIPTION
    Given a grid of letters, find the targey word that hides inside it.
    Words can be hidden in all kinds of directions: left-to-right, right-to-left, vertical and diagonal.

    Implement a class that will take in an array of string(s) represent the grid.
    Inside the class, implement a Search method that will take in a string as the target word.
    If found, return the result in an object that contain the location of the first and last letter.
    If the word doesn't exist in the grid, return $null.

    The object return must have these properties and their value in this format:
    - Start: @(row value, column value)
    - End  : @(row value, column value)
    Value of row and column follow the standard of 0-based index.

.EXAMPLE
    $grid = @(
        "jefblpepre",
        "camdcimgtc",
        "oivokprjsm",
        "pbwasqroua",
        "rixilelhrs",
        "wolcqlirpc",
        "screeaumgr",
        "alxhpburyi",
        "jalaycalmp",
        "clojurermt"
    )
    $puzzle = [WordSearch]::new($grid)
    $puzzle.Search("clojure")

    Returns: [PsCustomObject]@{
        Start = @(9, 0)
        End   = @(9, 6)
    }
#>
Class WordSearch {
    hidden [string[]]$Grid
    hidden [int]$Rows
    hidden [int]$Cols

    # Eight directions: horizontal, vertical, and both diagonals (both ways).
    hidden static [int[][]]$Directions = @(
        @(0, 1),   # left to right
        @(0, -1),  # right to left
        @(1, 0),   # top to bottom
        @(-1, 0),  # bottom to top
        @(1, 1),   # top-left to bottom-right
        @(-1, -1), # bottom-right to top-left
        @(1, -1),  # top-right to bottom-left
        @(-1, 1)   # bottom-left to top-right
    )

    WordSearch($grid) {
        $this.Grid = @($grid)
        $this.Rows = $this.Grid.Count
        $this.Cols = if ($this.Rows -gt 0) { $this.Grid[0].Length } else { 0 }
    }

    [object] Search($word) {
        if ([string]::IsNullOrEmpty($word) -or $this.Rows -eq 0) {
            return $null
        }

        $pattern = [regex]::Escape($word)

        foreach ($line in $this.GetDirectedLines()) {
            $match = [regex]::Match($line.Text, $pattern)
            if ($match.Success) {
                $start = $line.Positions[$match.Index]
                $end = $line.Positions[$match.Index + $word.Length - 1]
                return [PSCustomObject]@{
                    Start = @($start[0], $start[1])
                    End   = @($end[0], $end[1])
                }
            }
        }

        return $null
    }

    # Build every directed line as a string plus coordinate map so regex index -> (row, col).
    hidden [object[]] GetDirectedLines() {
        $lines = [System.Collections.Generic.List[object]]::new()

        foreach ($dir in [WordSearch]::Directions) {
            $dr = $dir[0]
            $dc = $dir[1]

            for ($r = 0; $r -lt $this.Rows; $r++) {
                for ($c = 0; $c -lt $this.Cols; $c++) {
                    # Start a line only at the first cell in this direction (no in-bounds predecessor).
                    $prevR = $r - $dr
                    $prevC = $c + $dc
                    if ($prevR -ge 0 -and $prevR -lt $this.Rows -and $prevC -ge 0 -and $prevC -lt $this.Cols) {
                        continue
                    }

                    $chars = [System.Text.StringBuilder]::new()
                    $positions = [System.Collections.Generic.List[int[]]]::new()
                    $cr = $r
                    $cc = $c

                    while ($cr -ge 0 -and $cr -lt $this.Rows -and $cc -ge 0 -and $cc -lt $this.Cols) {
                        [void]$chars.Append($this.Grid[$cr][$cc])
                        $positions.Add(@($cr, $cc))
                        $cr += $dr
                        $cc += $dc
                    }

                    if ($chars.Length -gt 0) {
                        $lines.Add([PSCustomObject]@{
                            Text      = $chars.ToString()
                            Positions = $positions.ToArray()
                        })
                    }
                }
            }
        }

        return $lines.ToArray()
    }
}
        