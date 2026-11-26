export const EXPECTED_MINUTES_IN_OVEN = 40 ;
export const actualMinutesInOven=25;
export const PREPARATION_MINUTES_PER_LAYER = 2;
export const numberOfLayer=4;


export function remainingMinutesInOven(actualMinutesInOven){
        return EXPECTED_MINUTES_IN_OVEN - actualMinutesInOven;
}

export function preparationTimeInMinutes(numberOfLayer) {
  return  numberOfLayer * PREPARATION_MINUTES_PER_LAYER;
}

export function totalTimeInMinutes(numberOfLayer,actualMinutesInOven) {
  return preparationTimeInMinutes(numberOfLayer) + actualMinutesInOven;
}



 
