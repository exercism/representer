module CarsAssemble

let private carsPerSpeed = 221

let successRate (speed: int) : float =
    match speed with
    | 0 -> 0
    | s when [ 1..4 ] |> Seq.contains s -> 1
    | s when [ 5..8 ] |> Seq.contains s -> 0.9
    | 9 -> 0.8
    | 10 -> 0.77
    | _ -> 0

let productionRatePerHour (speed: int) : float =
    let totalProduction = (float) (carsPerSpeed * speed)
    let calculatedSuccessRate = successRate speed
    totalProduction * calculatedSuccessRate

let workingItemsPerMinute (speed: int) : int =
    let itemsPerHour = productionRatePerHour speed
    let itemsPerMinute = itemsPerHour / 60.
    (int) itemsPerMinute
