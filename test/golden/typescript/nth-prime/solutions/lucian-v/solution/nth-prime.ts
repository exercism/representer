export function nth(n: number) {
  if (n === 0) {
    throw new Error('Prime is not possible')
  }

  let greatestCandidate = PRIMES[PRIMES.length - 1] + 1
  while(n > PRIMES.length) {
    if (isPrime(greatestCandidate)) {
      PRIMES.push(greatestCandidate)
    }
    greatestCandidate++
  }

  return PRIMES[n - 1]
}

const PRIMES = [2]

function isPrime(n: number) {
  for (let i = 0; PRIMES[i] <= n / 2; i++) {
    if (n % PRIMES[i] === 0) {
      return false
    }
  }
  return true
}