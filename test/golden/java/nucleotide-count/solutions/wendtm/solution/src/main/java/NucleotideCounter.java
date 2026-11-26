import java.util.HashMap;
import java.util.Map;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

class NucleotideCounter {

    private String dna;
    private Map<Character, Integer> nucleotides = new HashMap<>();

    NucleotideCounter(String dna) {

        String inValidPattern =  "[^ACGT]";
        Pattern pattern = Pattern.compile(inValidPattern);
        Matcher matcher = pattern.matcher(dna);

        if(matcher.find())
            throw new IllegalArgumentException("Input string does not resemble DNA squence.");

        this.dna = dna;

        Character[] nucleotideTypes = new Character[] {'A', 'C', 'G', 'T'};

        // initialize nucleotide counts
        for(Character nucleotide : nucleotideTypes)
            nucleotides.put(nucleotide, 0);
    }

    Map<Character, Integer> nucleotideCounts() {

        int dnaSize = dna.length();

        for (int i = 0; i < dnaSize; i++) {
            char nucleotide = dna.charAt(i);
            int count = nucleotides.get(nucleotide);
            nucleotides.replace(nucleotide, count + 1);
        }
        return nucleotides;
    }
}