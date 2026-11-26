export const EXPECTED_MINUTES_IN_OVEN = 40;
export const remainingMinutesInOven = function (minutes=30){
  return EXPECTED_MINUTES_IN_OVEN - minutes; 
}
export const preparationTimeInMinutes = function(layers=2){
  const MINUTES_PER_LAYER = 2;
  return layers*MINUTES_PER_LAYER;
}
export const totalTimeInMinutes = function(numberOfLayers=3,actualMinutesInOven=20){
  return preparationTimeInMinutes(numberOfLayers)+actualMinutesInOven;
}