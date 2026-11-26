<#
.SYNOPSIS
Implement basic list operations.

.DESCRIPTION
Implement a series of basic list operations, without using existing functions:
- `append` (*given two lists, add all items in the second list to the end of the first list*);
- `concatenate` (*given a series of lists, combine all items in all lists into one flattened list*);
- `filter` (*given a predicate and a list, return the list of all items for which `predicate(item)` is True*);
- `length` (*given a list, return the total number of items within it*);
- `map` (*given a function and a list, return the list of the results of applying `function(item)` on all items*);
- `foldl` (*given a function, a list, and initial accumulator, fold (reduce) each item into the accumulator from the left*);
- `foldr` (*given a function, a list, and an initial accumulator, fold (reduce) each item into the accumulator from the right*);
- `reverse` (*given a list, return a list with all the original items, but in reversed order*).

Note, the ordering in which arguments are passed to the fold functions (`foldl`, `foldr`) is significant.

.EXAMPLE
Invoke-Append -List1 @(1, 3) -List2 @(2, 4)
Returns: @(1, 3, 2, 4)

Invoke-Reverse -List @(1, 2, 3, 4, 5)
Returns: @(5, 4, 3, 2, 1)
#>
Function Invoke-Append() {
    [CmdletBinding()]
    Param(
        [object[]]$List1,
        [object[]]$List2
    )
    $output=@()
    $output += $list1
    $output += $list2
    return $output
}

Function Invoke-Concatenate() {
    [CmdletBinding()]
    Param(
        [object[]]$Lists
    )
    $output = @()
    $output += $lists | foreach-object {$_}
    return $output
}

Function Invoke-Filter() {
    [CmdletBinding()]
    Param(
        [object[]]$List,
        [scriptblock]$Predicate
    )
    return $list | Where-Object { & $predicate $_ }
}

Function Get-Length() {
    [CmdletBinding()]
    Param(
        [object[]]$List
    )
    return $list.count
}

Function Invoke-Map() {
    [CmdletBinding()]
    Param(
        [object[]]$List,
        [scriptblock]$Function
    )
    return $list | ForEach-Object { & $Function $_ }
}

Function Invoke-Foldl() {
    [CmdletBinding()]
    Param(
        [scriptblock]$Function,
        [object[]]$List,
        [object]$Accumulator
    )
    $list | ForEach-Object {$Accumulator = & $Function $Accumulator $_}
    return $Accumulator
}

Function Invoke-Foldr() {
    [CmdletBinding()]
    Param(
        [scriptblock]$Function,
        [object[]]$List,
        [object]$Accumulator
    )
    Invoke-Reverse $list | ForEach-Object {$Accumulator = & $Function $Accumulator $_}
    return $Accumulator
}

Function Invoke-Reverse() {
    [CmdletBinding()]
    Param(
        [object[]]$List
    )
    [array]::reverse($list)
    return $list
}
