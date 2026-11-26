module MariosMarvellousLasagna exposing (remainingTimeInMinutes)

-- TODO: define the remainingTimeInMinutes function
remainingTimeInMinutes layers elapsedMinutes = 
  let
    expectedMinutesInOven = 40
    preperationTime layerAmount = layerAmount * 2
  in
    expectedMinutesInOven + preperationTime layers + elapsedMinutes
