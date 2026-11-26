module LuciansLusciousLasagna exposing (elapsedTimeInMinutes, expectedMinutesInOven, preparationTimeInMinutes)

-- TODO: define the expectedMinutesInOven constant
-- TODO: define the preparationTimeInMinutes function
-- TODO: define the elapsedTimeInMinutes function


expectedMinutesInOven : Int
expectedMinutesInOven =
    40


preparationTimeInMinutes : Int -> Int
preparationTimeInMinutes numberOfLayers =
    numberOfLayers * 2


elapsedTimeInMinutes : Int -> Int -> Int
elapsedTimeInMinutes numberOfLayers actualMinutesInOven =
    preparationTimeInMinutes numberOfLayers + actualMinutesInOven
