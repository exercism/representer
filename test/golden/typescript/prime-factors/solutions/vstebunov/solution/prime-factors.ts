export function calculatePrimeFactors(n: number): number[] {
    const factors: number[] = [];
    let divider = 2;
    while(n > 1) {
        while (n % divider === 0) {
            factors.push(divider);
            n /= divider;
        }
        divider++;
    } 
    return factors;
}
