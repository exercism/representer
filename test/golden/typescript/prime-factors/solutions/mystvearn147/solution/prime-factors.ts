export function calculatePrimeFactors(input: number): number[] {
  if (input < 2) {
    return [];
  }

  const output: number[] = [];

  while (input % 2 === 0) {
    output.push(2);
    input /= 2;
  }

  for (let i = 3; i <= input; i += 2) {
    while (input % i === 0) {
      output.push(i);
      input /= i;
    }
  }

  return output;
}
