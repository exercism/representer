import java.util.HashMap;
import java.util.Map;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

public class NucleotideCounter {

    private String nucleotides;

    NucleotideCounter(String nucleotides) {

        Pattern p = Pattern.compile("[^ACGT]");
        Matcher m = p.matcher(nucleotides);
        if(m.find()) {
            throw new IllegalArgumentException("Please provide valid argument");
        }

        this.nucleotides = nucleotides;
    }

    public Map<Character, Integer> nucleotideCounts() {

        Map<Character, Integer> nucleotideCount = new HashMap<>();
        nucleotideCount.put('A', 0);
        nucleotideCount.put('C', 0);
        nucleotideCount.put('G', 0);
        nucleotideCount.put('T', 0);


        for(Character nucleotide : nucleotides.toCharArray()) {

            nucleotideCount.put(nucleotide, nucleotideCount.get(nucleotide) + 1);

        }

        return nucleotideCount;

    }

}
