export function calculatePrimeFactors(n: number): number[] {
  const factors: number[] = []
  let divisor = 2
  while (n > 1) {
    while (n % divisor === 0) {
      factors.push(divisor)
      n /= divisor
    }
    divisor++
  }
  return factors
}