module LuciansLusciousLasagna exposing (elapsedTimeInMinutes, expectedMinutesInOven, preparationTimeInMinutes)

-- TODO: define the expectedMinutesInOven constant
expectedMinutesInOven = 40

-- TODO: define the preparationTimeInMinutes function
preparationTimeInMinutes numberOfLayers = 
  2 * numberOfLayers

-- TODO: define the elapsedTimeInMinutes function
elapsedTimeInMinutes numberOfLayers minutesInOven = 
  minutesInOven + preparationTimeInMinutes numberOfLayers