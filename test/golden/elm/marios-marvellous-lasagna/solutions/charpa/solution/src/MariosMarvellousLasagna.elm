module MariosMarvellousLasagna exposing (remainingTimeInMinutes)

remainingTimeInMinutes : Int -> Int -> Int
remainingTimeInMinutes numberOfLayers minutesSinceStart =
    let expectedMinutesInOven = 40
        preparationTimeInMinutes nbLayers =
            nbLayers * 2
    in
         preparationTimeInMinutes numberOfLayers + expectedMinutesInOven - minutesSinceStart