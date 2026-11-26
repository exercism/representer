module SumOfMultiples
    
let sum (numbers: int list) (upperBound: int): int = 
    numbers
    |> Seq.filter (fun elem -> elem <> 0)
    |> Seq.collect (fun elem -> [ elem .. elem .. upperBound - 1 ])
    |> Seq.distinct
    |> Seq.sum