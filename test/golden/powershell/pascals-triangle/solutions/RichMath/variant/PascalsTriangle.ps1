Function Get-PascalsTriangleRows() {
    <#
    .SYNOPSIS
    Returns the first n rows of Pascal's triangle.
    
    .DESCRIPTION
    Given a count, returns the first n rows of Pascal's triangle.
    
    .PARAMETER Count
    The number of rows to return.
    
    .EXAMPLE
    Get-PascalsTriangleRows -Count 1
    
    Returns: @(
        @(1)
    )
    #>
    [CmdletBinding()]
    Param(
        [string]$Count
    )
    [array]$triangle = @()
    for ($line = 1; $line -le $Count; $line++) { 
        $coef = 1
        [array]$row = @()
        for ($i = 1; $i -le $line; $i++) { 
            # The first value in a line 
            # is always 1 
            $row += $Coef
            $coef = $coef / ($line - $i) / $i 
        } 
        $triangle += ,$row
    }
    $triangle
}