module LuciansLusciousLasagna exposing (elapsedTimeInMinutes, expectedMinutesInOven, preparationTimeInMinutes)

-- TODO: define the expectedMinutesInOven constant
-- TODO: define the preparationTimeInMinutes function
-- TODO: define the elapsedTimeInMinutes function

expectedMinutesInOven = 40
preparationTimeInMinutes x = x * 2
elapsedTimeInMinutes x y = (preparationTimeInMinutes x) + y