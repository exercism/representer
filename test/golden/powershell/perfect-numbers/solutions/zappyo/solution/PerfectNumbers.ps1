Function Invoke-PerfectNumbers() {
    <#
    .SYNOPSIS
    Determine if a number is perfect, abundant, or deficient based on Nicomachus' (60 - 120 CE) classification scheme for natural numbers.

    .DESCRIPTION
    Calculate the aliquot sum of a number: the sum of its positive divisors not including the number itself.
    Compare the sum to the original number.
    Determine the classification: perfect, abundant, or deficient.

    .PARAMETER Number
    The number to perform the classification on.

    .EXAMPLE
    Invoke-PerfectNumbers -Number 12
    #>
    [CmdletBinding()]
    Param(
        [Int64]$Number
    )
    if($Number -lt 1){
        Throw "error: Classification is only possible for positive integers."
    }
    
    $i = 1
    $sum = 0
    while($i -lt $Number){
        if($Number%$i -eq 0){
            $sum += $i
        }
        $i++
    }
    if($Number -eq $sum){
        Return "perfect"
    }
    if($Number -lt $sum){
        Return "abundant"
    }
    if($Number -gt $sum){
        Return "deficient"
    }

    Throw "Please implement this function"
}
