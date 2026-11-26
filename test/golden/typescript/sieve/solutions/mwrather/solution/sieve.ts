export function primes(limit: number): number[] {
  const map: Record<number, boolean> = {};
  const primes: number[] = [];

  for (let i = 2; i <= limit; i++) {
    if (typeof map[i] === 'boolean') {
      continue;
    }

    map[i] = true;
    primes.push(i);

    for (let j = i * i; j <= limit; j += i)
      map[j] = false; 
  }

  return primes;
}
