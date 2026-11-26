module MariosMarvellousLasagna exposing (remainingTimeInMinutes)


remainingTimeInMinutes : Int -> Int -> Int
remainingTimeInMinutes layerCount elapsedMinutes =
    let
        expectedMinutesInOven =
            40

        preparationTimeInMinutes =
            layerCount * 2
    in
    expectedMinutesInOven + preparationTimeInMinutes - elapsedMinutes
