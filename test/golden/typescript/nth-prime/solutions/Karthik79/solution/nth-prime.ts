export function nth(num: number): number {
  if (num < 1) throw Error("Prime is not possible")
  let primeArr: number[] = [2]
  let primeNum = 3
  while (primeArr.length < num) {
    let found = false
    for (let i = 2; i < primeNum; i++) {
      if (primeNum % i == 0) {
        found = true // factor beside 1 & self is found
        break
      }
    }
    if (!found) primeArr.push(primeNum)
    primeNum++
  }
  return primeArr[primeArr.length - 1]
}
