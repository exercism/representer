export function isLeap(year: number): boolean {
  const restofFour = year%4;
  const restOfGHundred = year%100
  const restOfFourHundred = year%400
  
  if (restofFour === 0) {
    if (year%100 === 0) {
      return restOfFourHundred === 0
    }
    return true;
  }
  return false
}
