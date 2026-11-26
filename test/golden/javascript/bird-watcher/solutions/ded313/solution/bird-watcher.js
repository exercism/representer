export function totalBirdCount(birdsPerDay) {
  let count = 0;
  for (let i=0; i < birdsPerDay.length; i++){
    count += birdsPerDay[i];
  }
  return count;
}

export function birdsInWeek(birdsPerDay, week) {
  let count = 0;
  const start = (week-1)*7;
  const end = week *7;
  for (let i=start; i < end; i++){
    count += birdsPerDay[i];
  }
  return count;
}

/**
 * Fixes the counting mistake by increasing the bird count
 * by one for every second day.
 *
 * @param {number[]} birdsPerDay
 * @returns {number[]} corrected bird count data
 */
export function fixBirdCountLog(birdsPerDay) {
  let count = 0;
  for (let i =0; i < birdsPerDay.length; i+=2){
    birdsPerDay[i]+=1
  }
  return birdsPerDay;
}
