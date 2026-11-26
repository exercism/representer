export function isLeap(year: number) {
  const dividedBy4And100 = year % 4 === 0 && year % 100 !== 0
  return dividedBy4And100 || year % 400 === 0
}