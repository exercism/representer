module CarsAssemble

let successRate speed =
    match speed with
    | 0 -> 0.0
    | s when s >= 1 && s <= 4 -> 1.0
    | s when s >= 5 && s <= 8 -> 0.9
    | 9 -> 0.8
    | 10 -> 0.77
    | _ -> failwith "unknown speed"

let productionRatePerHour speed = (successRate speed) * ((float speed) * 221.0)

let workingItemsPerMinute speed = (int (productionRatePerHour speed) / 60)
