module InterestIsInteresting

let interestRate (balance: decimal) : single =
    match balance with
    | x when x < 0m -> 3.213f
    | x when x < 1000m -> 0.5f
    | x when x < 5000m -> 1.621f
    | _ -> 2.475f

let interest (balance: decimal) : decimal =
    interestRate balance |> (fun x -> x / 100f) |> decimal |> (*) balance

let annualBalanceUpdate (balance: decimal) : decimal = balance + interest balance

let amountToDonate (balance: decimal) (taxFreePercentage: float) : int =
    if balance > 0m then
        (taxFreePercentage / 100.) |> decimal |> (*) balance |> (*) 2m |> int
    else
        0
