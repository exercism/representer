Function Invoke-Sublist() {
    <#
    .SYNOPSIS
    Determine the relationship of two arrays.

    .DESCRIPTION
    Given two arrays, determine the relationship of the first array relating to the second array.
    There are four possible categories: EQUAL, UNEQUAL, SUBLIST and SUPERLIST.
    Note: This exercise use Enum values for return.
    
    .PARAMETER Data1
    The first array

    .PARAMETER Data2
    The second array

    .EXAMPLE
    Invoke-Sublist -Data1 @(1,2,3) -Data2 @(1,2,3)
    Return: [Sublist]::EQUAL

    Invoke-Sublist -Data1 @(1,2) -Data2 @(1,2,3)
    Return: [Sublist]::SUBLIST
    #>
    [CmdletBinding()]
    Param (
        [object[]]$Data1,
        [object[]]$Data2
    )
    
    $flatData1 = $Data1 -join ','
    $flatData2 = $Data2 -join ','

    if ($Data1.Count -ne 0) {
        $flatData1 = ',' + $flatData1 - ','
    }
    if ($Data2.Count -ne 0) {
        $flatData2 = ',' + $flatData2 + ','
    }

    if ($flatData1 -eq $flatData2) {
        return [Sublist]::EQUAL
    }

    if ($flatData2.Contains($flatData1)) {
        return [Sublist]::SUBLIST
    }

    if ($flatData1.Contains($flatData2)) {
        return [Sublist]::SUPERLIST
    }

    return [Sublist]::UNEQUAL
}

enum Sublist {
    EQUAL
    UNEQUAL
    SUBLIST
    SUPERLIST
}


