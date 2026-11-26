Function Invoke-CollatzConjecture() {
    <#
    .SYNOPSIS
    Calculate the number of steps to reach 1 using the Collatz conjecture.

    .DESCRIPTION
    Take any positive integer n. If n is even, divide n by 2 to get n / 2. If n is odd, multiply n by 3 and add 1 to get 3n + 1. Repeat the process indefinitely. The conjecture states that no matter which number you start with, you will always reach 1 eventually.

    .PARAMETER Number
    The number to perform the Collatz Conjecture function on.

    .EXAMPLE
    Invoke-CollatzConjecture -Number 12
    #>
    [CmdletBinding()]
    Param(
        [Int64]$Number
    )

    $counter = 0
    while ($number -gt 1){
            if ($Number % 2 -eq 0){
                $Number /= 2
            }
            elseif ($Number % 2 -eq 1){
                $Number = ($Number * 3) + 1
            } 
        $counter++
    }
    
        
    if ($Number -eq 1){
        Break 
    } else {
        Throw "error: Only positive numbers are allowed"
    }

    

# needs to take in a number greater than 0
# set a counter equal to 0
# if else loop
# - if even divide by 2, return n, add one to counter
# - if odd multiple by 3 and add 1, return n, add one to counter
# end when number equals 1
    
}
