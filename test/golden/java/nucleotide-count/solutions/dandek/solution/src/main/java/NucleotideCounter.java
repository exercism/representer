import java.util.HashMap;
import java.util.Map;

public class NucleotideCounter {

    Map<Character, Integer> count = new HashMap<>();

    public NucleotideCounter(String nucleotide) {
        for (char c: "ACGT".toCharArray())
            count.put(c, 0);

        for (char c: nucleotide.toCharArray()) {
            if ("ACGT".indexOf(c) == -1)
                throw new IllegalArgumentException();
            int tmp = count.get(c);
            count.put(c, ++tmp);
        }
    }

    Map<Character, Integer> nucleotideCounts() {
        return count;
    }
}