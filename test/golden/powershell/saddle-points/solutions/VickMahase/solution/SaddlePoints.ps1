<#
.DESCRIPTION
A helper class act as a data structure for the saddle point.
It has a two properties: Row and Column, their indexes should be offset by 1 to reflect normal counting.
It also has an Equals method for comparison in tests.
Please don't delete or change this class.
#>
Class SaddlePoint {
    [int]$Row
    [int]$Column

    SaddlePoint($row, $col) {
        $this.Row = $row
        $this.Column = $col
    }

    [bool] Equals($other) {
        return $this.Row -eq $other.Row -and $this.Column -eq $other.Column
    }
}

Function Get-SaddlePoints() {
    <#
    .SYNOPSIS
    Find all the available saddle points in a given matrix.

    .DESCRIPTION
    Given a matrix (jagged arrays), return all the available saddle points found.
    The matrix can have a different number of rows and columns (non square), and it may have zero or more saddle points.

    It's called a "saddle point" because it is greater than or equal to every element in its row and less than or equal to every element in its column.

    Your code should be able to provide the (possibly empty) list of all the saddle points for any given matrix.

    .PARAMETER Matrix
    An array of arrays, each inner array contains number that could be a saddle point.

    .EXAMPLE
    Get-SaddlePoints -Matrix @( ,@(1, 2, 3))
    Returns: [SaddlePoint]::new(1, 3)
    #>
    [CmdletBinding()]
    Param(
        [int[][]]$Matrix
    )

    # Handle empty matrix case
    if ($Matrix.Count -eq 0) {
        return @()
    }

    # Check if matrix is irregular (all rows have the same length)
    $rowLength = $Matrix[0].Length
    for ($r = 0; $r -lt $Matrix.Count; $r++) {
        if ($Matrix[$r].Length -ne $rowLength) {
            throw "Irregular matrix"
        }
    }

    $saddlePoints = @()
    
    # Handle single row matrix special case
    if ($Matrix.Count -eq 1) {
        $maxValue = ($Matrix[0] | Measure-Object -Maximum).Maximum
        for ($col = 0; $col -lt $Matrix[0].Length; $col++) {
            if ($Matrix[0][$col] -eq $maxValue) {
                $saddlePoints += [SaddlePoint]::new(1, $col + 1)
            }
        }
        return $saddlePoints
    }
    
    # Handle single column matrix special case
    if ($rowLength -eq 1) {
        $minValue = ($Matrix | ForEach-Object { $_[0] } | Measure-Object -Minimum).Minimum
        for ($row = 0; $row -lt $Matrix.Count; $row++) {
            if ($Matrix[$row][0] -eq $minValue) {
                $saddlePoints += [SaddlePoint]::new($row + 1, 1)
            }
        }
        return $saddlePoints
    }
    
    # General case - handle normal matrices
    for ($rowIndex = 0; $rowIndex -lt $Matrix.Count; $rowIndex++) {
        $row = $Matrix[$rowIndex]
        $maxInRow = ($row | Measure-Object -Maximum).Maximum
        
        # Find all positions with the maximum value in the current row
        for ($colIndex = 0; $colIndex -lt $row.Length; $colIndex++) {
            if ($row[$colIndex] -eq $maxInRow) {
                # Check if this value is minimum in its column
                $column = @()
                for ($r = 0; $r -lt $Matrix.Count; $r++) {
                    $column += $Matrix[$r][$colIndex]
                }
                $minInColumn = ($column | Measure-Object -Minimum).Minimum
                
                if ($row[$colIndex] -eq $minInColumn) {
                    # Found a saddle point - add it with 1-based indexing
                    $saddlePoints += [SaddlePoint]::new($rowIndex + 1, $colIndex + 1)
                }
            }
        }
    }
    
    return $saddlePoints
}