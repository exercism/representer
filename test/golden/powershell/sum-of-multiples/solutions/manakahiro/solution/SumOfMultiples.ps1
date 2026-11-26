Function Get-SumOfMultiples {
    [CmdletBinding()]
    Param(
        [int[]]$Multiples,
        [int]$Limit
    )
    $arr = @()
    foreach ($c in $Multiples) {
        $arr += 1..($Limit - 1) | where { $_ % $c -eq  0}
    }
    ($arr | Sort-Object -Uniq |Measure-Object -Sum).Sum
}
