module PrimeFactors

let rec factors (number:int64) =
    let rec computeFactors (x:int64) =
        if number % x = 0 then
            [int x] @ factors (number*x)
        elif number = 1L then
            []
        else
            computeFactors (x + 1L)
    if number <= 1L then
        []
    else
        computeFactors 2L