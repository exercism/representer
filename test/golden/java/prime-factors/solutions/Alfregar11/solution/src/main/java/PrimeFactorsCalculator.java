import java.util.ArrayList;
import java.util.List;

class PrimeFactorsCalculator {

    List<Long> calculatePrimeFactorsOf(long number) {
        List<Long> factors = new ArrayList<>();
        long divisor = 2;

        // Iteramos mientras el número sea mayor a 1
        while (number > 1) {
            // Mientras el divisor actual divida exactamente al número
            while (number % divisor == 0) {
                factors.add(divisor); // Guardamos el factor
                number /= divisor;    // Reducimos el número
            }
            // Pasamos al siguiente posible divisor
            divisor++;
        }

        return factors;
    }
}