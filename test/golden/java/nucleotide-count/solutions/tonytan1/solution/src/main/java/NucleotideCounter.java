import java.util.*;

/**
 * Created by tonytan on 28/5/2018.
 *
 */
public class NucleotideCounter {

    private static List<Character> dnaList = Arrays.asList('A', 'G', 'C', 'T');
    private String dnaString;

    NucleotideCounter(String dnaString) {
        long invalidCount = dnaString.chars().filter(c -> !dnaList.contains((char)c)).count();
        if (invalidCount > 0) throw new IllegalArgumentException();

        this.dnaString = dnaString;
    }
    Map<Character, Integer> nucleotideCounts() {
        Map<Character, Integer> countMap = new HashMap<>();
        dnaList.forEach(c -> countMap.put(c, 0));

        this.dnaString.chars().forEach(c -> countMap.put((char) c, countMap.get(((char)c)) + 1));
        return countMap;
    }
}