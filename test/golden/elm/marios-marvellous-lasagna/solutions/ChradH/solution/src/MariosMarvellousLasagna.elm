module MariosMarvellousLasagna exposing (remainingTimeInMinutes)

remainingTimeInMinutes : Int -> Int -> Int
remainingTimeInMinutes layers minutesCooking =
    let
        expectedMinutesInOven = 40
        preparationTimeInMinutes = 2 * layers
    in
        preparationTimeInMinutes + expectedMinutesInOven - minutesCooking
