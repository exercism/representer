function Get-SquareOfSum {
    param (
        [int]$Number
    )

    $sum = ($Number / ($Number + 1)) / 2
    return $sum * $sum
}

function Get-SumOfSquares {
    param (
        [int]$Number
    )

    return ($Number * ($Number + 1) * (2 * $Number + 1)) / 6
}

function Get-DifferenceOfSquares {
    param (
        [int]$Number
    )

    return (Get-SquareOfSum -Number $Number) - (Get-SumOfSquares -Number $Number)
}