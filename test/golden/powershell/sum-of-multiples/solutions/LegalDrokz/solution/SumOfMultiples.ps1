Function Get-SumOfMultiples {
    <#
    .SYNOPSIS
    Given a number, find the sum of all the unique multiples of particular numbers up to
    but not including that number.

    .DESCRIPTION
    If we list all the natural numbers below 20 that are multiples of 3 or 5,
    we get 3, 5, 6, 9, 10, 12, 15, and 18.

    .PARAMETER Multiples
    An array of the factors 

    .PARAMETER Limit
    The value BELOW which we test for

    .EXAMPLE
    Get-SumOfMultiples -Multiples @(3, 5) -Limit 10
    
    Returns 23
    #>
    [CmdletBinding()]
    Param(
        [int[]]$Multiples,
        [int]$Limit
    )
    if (!$Multiples) { return '0' }
    $amountArray = @()
    ForEach ($multiple in $Multiples) {
        if ($multiple -lt $limit) {
            $itFits = $true
            [int]$iterationLimit = $limit - $limit % $multiple
            #Write-Host 'current multple is' $multiple
            #Write-Host 'current iterationlimit is '$iterationLimit

            do {
                $iterationLimit = $iterationLimit - $multiple
                [int]$iterationSum = $iterationSum + $multiple
                if ([int]$iterationSum -ne $limit) { $amountArray += [int]$iterationSum }
                #Write-Host 'current iterationlimit' $iterationLimit
                #Write-Host 'current iterationsum' $iterationSum
                #Write-Host 'current iterationAmount' $iterationAmount

            } until ($iterationLimit -eq 0)
            $iterationSum = ''
            $iterationLimit = ''
        
        }
        if (!$itFits -eq $true ) { Return '0' }
    }
    $amountArray = $amountArray | Sort-object | Get-Unique
    foreach ($amount in $amountArray) {
        #write-host 'amount is' $amount
        $total = [int]$total + [int]$amount
    }
    Return $total
    #Throw "Function not implemented"
}
