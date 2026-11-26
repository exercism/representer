Function Invoke-OCR() {
    [CmdletBinding()]
    Param(
        [string[]]$Grid
    )

    if (($Grid.Count % 4) -ne 0) {
        throw "Number of input lines is not a multiple of four"
    }

    if ($Grid.Count -eq 0) {
        return ""
    }

    $width = $Grid[0].Length

    if (($width % 3) -ne 0) {
        throw "Number of input columns is not a multiple of three"
    }

    foreach ($line in $Grid) {
        if ($line.Length -ne $width) {
            throw "Number of input columns is not a multiple of three"
        }
    }

    $patterns = @{
        " _ `n| |`n|_|`n   " = "0"
        "   `n  |`n  |`n   " = "1"
        " _ `n _|`n|_ `n   " = "2"
        " _ `n _|`n _|`n   " = "3"
        "   `n|_|`n  |`n   " = "4"
        " _ `n|_ `n _|`n   " = "5"
        " _ `n|_ `n|_|`n   " = "6"
        " _ `n  |`n  |`n   " = "7"
        " _ `n|_|`n|_|`n   " = "8"
        " _ `n|_|`n _|`n   " = "9"
    }

    $output = @()

    for ($baseRow = 0; $baseRow -lt $Grid.Count; $baseRow += 4) {

        $number = ""

        for ($column = 0; $column -lt $width; $column += 3) {

            $parts = @()

            for ($row = 0; $row -lt 4; $row++) {
                $parts += $Grid[$baseRow + $row].Substring($column, 3)
            }

            $pattern = $parts -join "`n"

            if ($patterns.ContainsKey($pattern)) {
                $number += $patterns[$pattern]
            }
            else {
                $number += "?"
            }
        }

        $output += $number
    }

    $output -join ","
}