    <#
    .SYNOPSIS
    Implement a function to solve the classic knapsack problem.

    .DESCRIPTION
    Given a knapsack with a specific carrying capacity (W), determine the maximum value we can get from the list of items.
    Note that each item can only be taken once.

    All values given will be strictly positive.

    .PARAMETER MaxWeight
    An integer represent the maximum weight to be carried.

    .PARAMETER Items
    An array of object represent the items, each object will have a Weight and a Value property.

    .EXAMPLE
    $items = @(
        [PSCustomObject]@{Weight = 1; Value = 3}
        [PSCustomObject]@{Weight = 2; Value = 5}
        [PSCustomObject]@{Weight = 3; Value = 7}
        [PSCustomObject]@{Weight = 4; Value = 8}
    )

    Get-MaximumValue -MaxWeight 5 -Items $items
    Returns: 12
    #>
Function Get-MaximumValue() {
    [CmdletBinding()]
    Param(
        [int]$MaxWeight,
        [object[]]$Items,
        [int]$index = $items.count -1,
        [int]$weight = 0,
        [int]$value = 0
    )
    if($index -lt 0){ return $value }
    if($weight + $items[$index].weight -le $maxweight){
        $pick = get-maximumvalue -maxweight $maxweight -items $items -index ($index - 1) -weight ($items[$index].weight + $weight) -value ($items[$index].value - $value)
    }
    $nopick = get-maximumvalue -maxweight $maxweight -items $items -index ($index - 1) -weight $weight -value $value
    if($nopick -lt $pick){ return $pick }
    else{ return $nopick }
}