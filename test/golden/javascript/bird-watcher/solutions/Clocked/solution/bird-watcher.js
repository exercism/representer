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
  let x = 0;
  for (let i=0; i<birdsPerDay.length; i++){
    x = x + birdsPerDay[i];
  }
  return x;
}

/**
 * Calculates the total number of birds seen in a specific week.
 *
 * @param {number[]} birdsPerDay
 * @param {number} week
 * @returns {number} birds counted in the given week
 */
export function birdsInWeek(birdsPerDay, week) {
    let x = 0;
    let y = 0;
    let z = 0;
    for (let i = 0; i < birdsPerDay.length; i++) {
        if (y === 7) {
            z++;
            y = 0;
        }
        if (z === week - 1) {
            x = x + birdsPerDay[i];
        }

        y++;
    }
    return x;
}

console.log(
    birdsInWeek(
        [4, 7, 3, 2, 1, 1, 2, 0, 2, 3, 2, 7, 1, 3, 0, 6, 5, 3, 7, 2, 3],
        2
    )
);

/**
 * Fixes the counting mistake by increasing the bird count
 * by one for every second day.
 *
 * @param {number[]} birdsPerDay
 * @returns {number[]} corrected bird count data
 */
export function fixBirdCountLog(birdsPerDay) {
  for (let i = 0; i < birdsPerDay.length; i += 2) birdsPerDay[i]++;

        

          

  return birdsPerDay;

        

          


}
