export function primes(limit: number): number[] {
    const primesList: number[] = [];
    for (let i = 2; i <= limit; i++) {
      let isPrime = true;
      for (let j = 2; j <= Math.sqrt(i); j++) {
        if (i % j === 0) {
          isPrime = false;
          break;
        }
      }
      if (isPrime) {
        primesList.push(i);
      }
    }
    return primesList;
}
