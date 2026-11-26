Function Invoke-Row() {
    <#
    .SYNOPSIS
    Get a row from a matrix.
    
    .DESCRIPTION
    Given a string containing newlines, extract the given row from the matrix.
    
    .PARAMETER String
    The matrix as a string

    .PARAMETER Index
    The index of the row to extract
    
    .EXAMPLE
    Invoke-Row -String "1 2\n3 4" -Index 2
    
    Returns: @(3, 4)
    #>
    [CmdletBinding()]
    Param(
        [string]$String,
        [int]$Index
    )

    # Split the string into rows
    $rows = $String -split '\r?\n'

    # Validate index (adjust for 1-based indexing)
    if ($Index -lt 1 -or $Index -gt $rows.Count) {
        throw "Invalid row index"
    }

    # Split the specific row into numbers and convert to integers
    return ($rows[$Index - 1] -split '\s+' | Where-Object { $_ -ne '' } | ForEach-Object { [int]::Parse($_) })
}

Function Invoke-Column() {
    <#
    .SYNOPSIS
    Get a column from a matrix.
    
    .DESCRIPTION
    Given a string containing newlines, extract the given column from the matrix.
    
    .PARAMETER String
    The matrix as a string

    .PARAMETER Index
    The index of the column to extract
    
    .EXAMPLE
    Invoke-Column -String "1 2 3\n4 5 6\n7 8 9" -Index 3
    
    Returns: @(3, 6, 9)
    #>
    [CmdletBinding()]
    Param(
        [string]$String,
        [int]$Index
    )

    # Split the string into rows
    $rows = $String -split '\r?\n'

    # Create array to hold column values
    $columnNumbers = @()

    foreach ($row in $rows) {
        # Split row into numbers
        $rowNumbers = $row -split '\s+' | Where-Object { $_ -ne '' }
        
        # Validate column index
        if ($Index -lt 1 -or $Index -gt $rowNumbers.Count) {
            throw "Invalid column index"
        }
        
        # Add the specific column number to our result array
        $columnNumbers += [int]::Parse($rowNumbers[$Index + 1])
    }

    return $columnNumbers
}