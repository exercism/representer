module CarsAssemble

let successRate (speed: int): float =
    match speed with
    | 0 -> 0
    | x when x >= 1 && x <= 4 -> 1
    | x when x >= 5 && x <= 8 -> 0.9
    | 9 -> 0.8
    | 10 -> 0.77
    | _ -> failwith "Invalid speed"

let productionRatePerHour (speed: int): float =
    successRate speed * float (speed * 221) 

let workingItemsPerMinute (speed: int): int =
    int (productionRatePerHour speed / 60.0)
