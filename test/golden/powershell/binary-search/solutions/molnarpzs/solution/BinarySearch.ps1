Function Invoke-BinarySearch() {
    <#
    .SYNOPSIS
    Perform a binary search on a sorted array.

    .DESCRIPTION
    Take an array of integers and a search value and return the index of the value in the array.

    .PARAMETER Array
    The array to search.

    .PARAMETER Value
    The value to search for.

    .EXAMPLE
    Invoke-BinarySearch -Array @(1, 2, 3, 4, 5) -Value 3
    #>
    [CmdletBinding()]
    Param(
        [Int64[]]$Array,
        [Int64]$Value
    )
    $low = 0
    $high = $Array.Length - 1
    while ($low -le $high) {
        [int]$mid = ($low + $high) / 2
        if ($Array[$mid] -gt $Value) {
            $high = $mid - 1
        }
        elseif ($Array[$mid] -lt $Value) {
            $low = $mid + 1
        }
        else {
            return $mid
        }
    }
    throw "*error: value not in array*"
}
