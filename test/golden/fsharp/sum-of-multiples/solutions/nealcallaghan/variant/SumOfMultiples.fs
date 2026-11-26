module SumOfMultiples

let sum (numbers: int list) (upperBound: int): int =
    [1..upperBound+1] 
    |> List.filter(fun x -> numbers |> List.exists(fun e -> e <> 0 && x % e = 0))
    |> List.distinct
    |> List.sum
    