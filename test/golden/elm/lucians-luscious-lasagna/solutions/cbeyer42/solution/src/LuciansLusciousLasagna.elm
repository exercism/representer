module LuciansLusciousLasagna exposing (elapsedTimeInMinutes, expectedMinutesInOven, preparationTimeInMinutes)

-- TODO: define the expectedMinutesInOven constant
expectedMinutesInOven = 40
preparationTimePerLayer = 2
-- TODO: define the preparationTimeInMinutes function
preparationTimeInMinutes numberOfLayers = 
                         numberOfLayers * preparationTimePerLayer
-- TODO: define the elapsedTimeInMinutes function
elapsedTimeInMinutes numberOfLayers timeAlreadySpent =
                     preparationTimeInMinutes numberOfLayers + timeAlreadySpent