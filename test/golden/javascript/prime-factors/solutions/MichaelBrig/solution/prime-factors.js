//
// This is only a SKELETON file for the 'Prime Factors' exercise. It's been provided as a
// convenience to get you started writing code faster.
//

export const primeFactors = (number) => {
  let primes = [];

  for(let i = 2; i <= number;){
    number % i === 0 ? primes.push(i) && (number /= i) : i++;
  }

  return primes;
};
