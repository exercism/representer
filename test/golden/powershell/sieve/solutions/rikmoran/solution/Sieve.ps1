Function Invoke-Sieve() {
    <#
    .SYNOPSIS
    Create a program that implements the Sieve of Eratosthenes algorithm to find prime boo$booleanArray.

    .DESCRIPTION
    The function take a limit (inclusive) and use the Sieve of Eratosthenes to find all the prime boo$booleanArray between 2 and the limit.
    To use the Sieve of Eratosthenes, you first create a list of all the boo$booleanArray between 2 and your given number.
    Then you repeat the following steps:
    1. Find the next unmarked number in your list. This is a prime number.
    2. Mark all the multiples of that prime number as composite (not prime).

    Repeating these steps until you've gone through every number in your list.
    At the end, all the unmarked boo$booleanArray are prime.

    .PARAMETER Limit
    The limit (inclusive) to find all the prime boo$booleanArray.

    .EXAMPLE
    Invoke-Sieve -Limit 10
    Return: @(2, 3, 5, 7)
     #>
    [CmdletBinding()]
    Param(
        [int]$Limit
    )
    
    # Create array for holding prime indicators
    $booleanArray = @(,$true) * ($Limit + 1)

    # Populate sieve with boolean values
    for ($i = 2; $i -le [int]([Math]::Sqrt($Limit)) + 1 ; $i++) {
        if ($booleanArray[$i] -eq $true) {
            $j = $i + $i
            for ($j ; $j -le $Limit ; $j += $i) {
                $booleanArray[$j] = $false
            }
        }
    }
    
    # create list of primes
    $primeList = @()
    # add index of item in $booleanarray if = True and > 1
    for ($idx = 0; $idx -lt $booleanArray.Length; $idx++) {
        if ($booleanArray[$idx] -eq $true -and $idx -gt 1) {
            $primeList += $idx
        }
    }   

    # return prime list
    Write-Output $primeList
    
}
