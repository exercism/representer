module LuciansLusciousLasagna exposing (elapsedTimeInMinutes, expectedMinutesInOven, preparationTimeInMinutes)

-- TODO: define the expectedMinutesInOven constant
-- TODO: define the preparationTimeInMinutes function
-- TODO: define the elapsedTimeInMinutes function

expectedMinutesInOven = 40

preparationTimeInMinutes layersNb = 2 * layersNb

elapsedTimeInMinutes layersNb spentTime =
    (preparationTimeInMinutes layersNb) + spentTime
