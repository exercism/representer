import java.util.ArrayList;
import java.util.LinkedList;
import java.util.List;

class Sieve {
    private final int maxPrime;

    public Sieve(int maxPrime) {
        this.maxPrime = maxPrime;
    }

    List<Integer> getPrimes() {
        if(maxPrime < 2) return new LinkedList<Integer>();
        LinkedList<Integer> primes = new LinkedList<Integer>();
        LinkedList<Integer> nums = new LinkedList<Integer>();

        for(int i = 2;i <= maxPrime;i++){
            nums.add(i);
        }

        while(nums.size() > 0){
            int nextPrime = nums.remove();
            for(int i = nextPrime * nextPrime;i <= maxPrime;i += nextPrime){
                nums.removeFirstOccurrence(i);
            }
            primes.add(nextPrime);
        }
        return primes;
    }
}
