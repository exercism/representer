Function Get-Products() {
    <#
    .SYNOPSIS
    Detect palindrome products in a given range.

    .DESCRIPTION
    A palindromic number is a number that remains the same when its digits are reversed.
    For example, `121` is a palindromic number but `112` is not.

    Given a range of numbers, find the largest and smallest palindromes which
    are products of two numbers within that range.

    Your solution should return the largest and smallest palindromes, along with the factors of each within the range.
    If the largest or smallest palindrome has more than one pair of factors within the range, then return all the pairs.

    .PARAMETER Min
    The minimum value of the range to find palindrome products.
    Min can't be larger than Max.
    
    .PARAMETER Max
    The maximum value of the range to find palindrome products.
    Max can't be smaller than Min. Parameter contrainst should be placed on this parameter.

    .PARAMETER Largest
    A switch parameter, present to return the largest palindrome.
    If not present then default behavior of the function should be return the smallest palindrome.

    .EXAMPLE
    Get-Products -Min 1 -Max 9
    Returns : @{ Value = 1; Products = @( @(1, 1)) }

    Get-Products -Min 1 -Max 9 -Largest
    Returns : @{ Value = 9; Products = @( @(1, 9), @(3, 3)) }
    #>
    [CmdletBinding()]
    Param(
        [int]$Min,
        [int]$Max,
        [switch]$Largest
    )
    if($min -gt $max){ throw "*Cannot validate argument on parameter 'Max'*" }
    
    if($largest){ $first = $max; $second = $min; $alt = $first - 150}
    else{ $first = $min; $second = $max; $alt = $first + 150 }
    if($max - $min -gt 100){$firstarr = @($first..$alt) | Where-Object { $_ % 2 -eq 1 } }
	else{ $firstArr = @($first..$second) | Where-Object { $_ % 2 -eq 1 } }
    
    $value = $null
    foreach($n in $firstArr){
        foreach($x in $firstArr){
            $found = $false
            $product = $n * $x
            $str = [string]$product
            if($found -eq $false){
                if((compare-object $str[0..$str.length] $str[$str.length..0] -syncwindow 0) -eq $null -and $product -ne 0){
                    if($product -eq $value){ $productarr += ,(@($n,$x) | sort-object) }
                    if($value -eq $null){ $value = $product; $productarr += ,(@($n,$x) | sort-object)  }
                    if($largest){ if($product -gt $value){ $value = $product; $productarr = ,(@($n,$x) | sort-object) } }
                    else{ if($product -lt $value){$value = $product; $productarr = ,(@($n,$x) | sort-object) } }
                }
            }
        }
    }
    return @{ Value = $value; Products = @($productarr | select -unique) }
}