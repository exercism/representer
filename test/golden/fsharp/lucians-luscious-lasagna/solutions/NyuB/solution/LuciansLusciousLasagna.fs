module LuciansLusciousLasagna

let expectedMinutesInOven = 40

let remainingMinutesInOven already = expectedMinutesInOven - already

let preparationTimeInMinutes layers = layers * 2

let elapsedTimeInMinutes layers already = preparationTimeInMinutes layers + already
