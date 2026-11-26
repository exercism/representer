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

    # Split the string by newlines to get rows
    $rows = $String -split "`n"
    
    # Validate index
    if ($Index -lt 1 -or $Index -gt $rows.Count) {
        throw "Index out of range"
    }
    
    # Get the specified row (convert 1-based index to 0-based)
    $rowString = $rows[$Index - 1]
    
    # Split by spaces and convert to integers
    $result = @()
    $numbers = $rowString -split ' '
    foreach ($num in $numbers) {
        if ($num -ne '') {
            $result += [int]$num
        }
    }
    
    return $result
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

    # Split the string by newlines to get rows
    $rows = $String -split "`n"
    
    if ($rows.Count -eq 0) {
        throw "Matrix is empty"
    }
    
    # Parse all rows into integer arrays
    $matrix = @()
    foreach ($row in $rows) {
        $numbers = $row -split ' '
        $rowArray = @()
        foreach ($num in $numbers) {
            if ($num -ne '') {
                $rowArray += [int]$num
            }
        }
        $matrix += ,$rowArray
    }
    
    # Get the number of columns from the first row
    $columnCount = $matrix[0].Count
    
    # Validate index
    if ($Index -lt 1 -or $Index -gt $columnCount) {
        throw "Index out of range"
    }
    
    # Extract the specified column (convert 1-based index to 0-based)
    $result = @()
    $colIndex = $Index - 1
    for ($i = 0; $i -lt $matrix.Count; $i++) {
        $result += $matrix[$i][$colIndex]
    }
    
    return $result
}

# Optional: Additional helper function to get the entire matrix
Function Get-Matrix() {
    <#
    .SYNOPSIS
    Get the entire matrix as a 2D array.
    
    .DESCRIPTION
    Given a string containing newlines, return the full matrix.
    
    .PARAMETER String
    The matrix as a string
    
    .EXAMPLE
    Get-Matrix -String "1 2\n3 4"
    
    Returns: @(@(1, 2), @(3, 4))
    #>
    [CmdletBinding()]
    Param(
        [string]$String
    )
    
    $rows = $String -split "`n"
    $matrix = @()
    
    foreach ($row in $rows) {
        $numbers = $row -split ' '
        $rowArray = @()
        foreach ($num in $numbers) {
            if ($num -ne '') {
                $rowArray += [int]$num
            }
        }
        $matrix += ,$rowArray
    }
    
    return $matrix
}

# Pester tests for verification
if ($MyInvocation.InvocationName -ne '.') {
    Describe "Matrix Operations" {
        Context "Invoke-Row" {
            It "Gets first row from 2x2 matrix" {
                $result = Invoke-Row -String "1 2`n3 4" -Index 1
                $result.Count | Should -Be 2
                $result[0] | Should -Be 1
                $result[1] | Should -Be 2
            }
            
            It "Gets second row from 2x2 matrix" {
                $result = Invoke-Row -String "1 2`n3 4" -Index 2
                $result.Count | Should -Be 2
                $result[0] | Should -Be 3
                $result[1] | Should -Be 4
            }
            
            It "Gets row from 3x3 matrix" {
                $result = Invoke-Row -String "1 2 3`n4 5 6`n7 8 9" -Index 2
                $result.Count | Should -Be 3
                $result[0] | Should -Be 4
                $result[1] | Should -Be 5
                $result[2] | Should -Be 6
            }
            
            It "Throws on invalid index" {
                { Invoke-Row -String "1 2`n3 4" -Index 3 } | Should -Throw "Index out of range"
            }
            
            It "Throws on zero index" {
                { Invoke-Row -String "1 2`n3 4" -Index 0 } | Should -Throw "Index out of range"
            }
        }
        
        Context "Invoke-Column" {
            It "Gets first column from 2x2 matrix" {
                $result = Invoke-Column -String "1 2`n3 4" -Index 1
                $result.Count | Should -Be 2
                $result[0] | Should -Be 1
                $result[1] | Should -Be 3
            }
            
            It "Gets second column from 2x2 matrix" {
                $result = Invoke-Column -String "1 2`n3 4" -Index 2
                $result.Count | Should -Be 2
                $result[0] | Should -Be 2
                $result[1] | Should -Be 4
            }
            
            It "Gets column from 3x3 matrix" {
                $result = Invoke-Column -String "1 2 3`n4 5 6`n7 8 9" -Index 3
                $result.Count | Should -Be 3
                $result[0] | Should -Be 3
                $result[1] | Should -Be 6
                $result[2] | Should -Be 9
            }
            
            It "Gets middle column from 3x3 matrix" {
                $result = Invoke-Column -String "1 2 3`n4 5 6`n7 8 9" -Index 2
                $result.Count | Should -Be 3
                $result[0] | Should -Be 2
                $result[1] | Should -Be 5
                $result[2] | Should -Be 8
            }
            
            It "Throws on invalid index" {
                { Invoke-Column -String "1 2`n3 4" -Index 3 } | Should -Throw "Index out of range"
            }
            
            It "Throws on zero index" {
                { Invoke-Column -String "1 2`n3 4" -Index 0 } | Should -Throw "Index out of range"
            }
        }
        
        Context "Get-Matrix" {
            It "Returns full 2x2 matrix" {
                $result = Get-Matrix -String "1 2`n3 4"
                $result.Count | Should -Be 2
                $result[0].Count | Should -Be 2
                $result[1].Count | Should -Be 2
                $result[0][0] | Should -Be 1
                $result[0][1] | Should -Be 2
                $result[1][0] | Should -Be 3
                $result[1][1] | Should -Be 4
            }
            
            It "Returns full 3x3 matrix" {
                $result = Get-Matrix -String "1 2 3`n4 5 6`n7 8 9"
                $result.Count | Should -Be 3
                $result[0].Count | Should -Be 3
                $result[1].Count | Should -Be 3
                $result[2].Count | Should -Be 3
                $result[0][0] | Should -Be 1
                $result[0][1] | Should -Be 2
                $result[0][2] | Should -Be 3
                $result[1][0] | Should -Be 4
                $result[1][1] | Should -Be 5
                $result[1][2] | Should -Be 6
                $result[2][0] | Should -Be 7
                $result[2][1] | Should -Be 8
                $result[2][2] | Should -Be 9
            }
        }
        
        Context "Integration" {
            It "Row and column extraction work together" {
                $matrixString = "1 2 3`n4 5 6`n7 8 9"
                
                # Get row 2
                $row2 = Invoke-Row -String $matrixString -Index 2
                $row2[0] | Should -Be 4
                $row2[1] | Should -Be 5
                $row2[2] | Should -Be 6
                
                # Get column 2
                $col2 = Invoke-Column -String $matrixString -Index 2
                $col2[0] | Should -Be 2
                $col2[1] | Should -Be 5
                $col2[2] | Should -Be 8
                
                # The intersection (row2, col2) should be 5
                $row2[1] | Should -Be 5
                $col2[1] | Should -Be 5
            }
        }
    }
}