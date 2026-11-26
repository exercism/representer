import java.util.ArrayList;
import java.util.List;

class PrimeFactorsCalculator {

    List<Long> calculatePrimeFactorsOf(long number) {
        List<Long> factors = new ArrayList<>();
        long candidate = 2;
        while (number > 1) {
            while (number % candidate == 0) {
                factors.add(candidate);
                number /= candidate;
            }
            candidate ++;
        }
        return factors;
    }

}