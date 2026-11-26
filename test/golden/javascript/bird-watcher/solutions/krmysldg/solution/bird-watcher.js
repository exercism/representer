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
    let totalBird = 0;
    for(let day = 0; day < birdsPerDay.length; day++){
        totalBird = totalBird + birdsPerDay[day]
    }
    return totalBird;
  }
  
  /**
   * Calculates the total number of birds seen in a specific week.
   *
   * @param {number[]} birdsPerDay
   * @param {number} week
   * @returns {number} birds counted in the given week
   */
  export function birdsInWeek(birdsPerDay, week) {
    let startOfTheWeek = (week - 1) * 7;
    let endOfTheWeek = startOfTheWeek + 7;
    let totalBirds = 0;
    for (let i = startOfTheWeek; i < endOfTheWeek; i++) {
      totalBirds += birdsPerDay[i];
    }
    return totalBirds;
  }
  
  /**
   * Fixes the counting mistake by increasing the bird count
   * by one for every second day.
   *
   * @param {number[]} birdsPerDay
   * @returns {number[]} corrected bird count data
   */
  export function fixBirdCountLog(birdsPerDay) {
    for (let i = 0; i < birdsPerDay.length; i += 2) {
        birdsPerDay[i] += 1
    }
    return birdsPerDay;
  }
  