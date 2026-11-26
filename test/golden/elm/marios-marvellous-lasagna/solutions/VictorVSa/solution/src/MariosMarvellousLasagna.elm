module MariosMarvellousLasagna exposing (remainingTimeInMinutes)

-- TODO: define the remainingTimeInMinutes function


remainingTimeInMinutes : Int -> Int -> Int
remainingTimeInMinutes layers minutesCooking =
    let
        expectedMinutesInOven =
            40

        preparationTimeInminutes =
            layers * 2
    in
    preparationTimeInminutes + expectedMinutesInOven - minutesCooking
