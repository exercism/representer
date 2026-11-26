export function calculatePrimeFactors(number: number): number[] {
    // Array para almacenar los factores primos
    const primeFactors: number[] = [];

    // Comenzamos con el divisor más pequeño
    let divisor = 2;

    // Mientras el número sea mayor que 1
    while (number > 1) {
        // Si el número es divisible por el divisor actual
        while (number % divisor === 0) {
            // Añadimos el divisor a la lista de factores primos
            primeFactors.push(divisor);
            // Dividimos el número por el divisor
            number /= divisor;
        }
        // Pasamos al siguiente posible divisor
        divisor++;
    }

    return primeFactors;
}
