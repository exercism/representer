// @ts-check
//
// The line above enables type checking for this file. Various IDEs interpret
// the @ts-check directive. It will give you helpful autocompletion when
// implementing this exercise.

/**
 * Calculates the total bird count.
 *
 * @param {number[]} birdsPerDay
 * @returns {number} total bird count
 */
export function totalBirdCount(birdsPerDay) {
  let sum = 0;
 for(let i = 0 ; i <birdsPerDay.length ; i++){
    sum += birdsPerDay[i];
 }
  return sum;
}

/**
 * Calculates the total number of birds seen in a specific week.
 *
 * @param {number[]} birdsPerDay
 * @param {number} week
 * @returns {number} birds counted in the given week
 */
export function birdsInWeek(birdsPerDay, week) {
 let weeks = [];
    let W = [];
    for(let i = 0 ; i < birdsPerDay.length ; i++){
      W.push(birdsPerDay[i]);
      console.log(week)
      if(W.length === 7){
        weeks.push(W)
        W = []
      }
    }
    return totalBirdCount(weeks[week - 1]);
}

/**
 * Fixes the counting mistake by increasing the bird count
 * by one for every second day.
 *
 * @param {number[]} birdsPerDay
 * @returns {number[]} corrected bird count data
 */
export function fixBirdCountLog(birdsPerDay) {
 for (let i = 0; i < birdsPerDay.length; i++) {
       i % 2 ? birdsPerDay[i] : birdsPerDay[i]+=1;
      
    }
    return birdsPerDay;
}
