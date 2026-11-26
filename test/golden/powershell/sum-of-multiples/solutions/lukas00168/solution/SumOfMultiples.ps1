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

    $res = 0;

    for ($i = 1; $i -lt $Limit; $i++) {    #goes through all numbers smaller than the Limit
        for ($m = 0; $m -lt $Multiples.Length; $m++){   #goes through all Numbers of $Multiples
            if ($i % $Multiples[$m] -eq 0){     #checks if the number is a multiple of one of the given in $Multiples
                $res = $res + $i;   
                break;      #go out of the Loop, so if the number is an muliple of more than one number it doesn't get counted twice
            }
        }
        
            
        
    }
    return $res;

    Throw "Function not implemented"
}
