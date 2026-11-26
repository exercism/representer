import java.util.HashMap;
import java.util.Map;

public class NucleotideCounter {
    private final String dna;

    public NucleotideCounter(String dna) {
        if (dna.matches(".*[^ATCG].*")) {
            throw new IllegalArgumentException();
        }

        this.dna = dna;
    }

    public Map<Character, Integer> nucleotideCounts() {
         HashMap<Character, Integer> map = new HashMap<>();
         map.put('A', 0);
         map.put('T', 0);
         map.put('C', 0);
         map.put('G', 0);

         for (char base : dna.toCharArray()) {
             map.put(base, map.get(base) + 1);
         }

        return map;
    }
}
