module LuciansLusciousLasagna exposing (elapsedTimeInMinutes, expectedMinutesInOven, preparationTimeInMinutes)

-- TODO: define the expectedMinutesInOven constant
-- TODO: define the preparationTimeInMinutes function
-- TODO: define the elapsedTimeInMinutes function

expectedMinutesInOven = 40
preparationTimeInMinutes n = n * 2
elapsedTimeInMinutes n m = preparationTimeInMinutes n + m
