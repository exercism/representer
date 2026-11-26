import java.util.Map;
import java.util.TreeMap;
class NucleotideCounter {
    private String sequence;
    
    NucleotideCounter(String sequence) {
        this.sequence = sequence;
        for(int i = 0; i < sequence.length(); i++) {
			if(sequence.charAt(i) != 'A' && 
               sequence.charAt(i) != 'C' && 
               sequence.charAt(i) != 'G' && 
               sequence.charAt(i) != 'T') {
                throw new IllegalArgumentException("caracter invalido: " +
                                                   sequence.charAt(i));
				
			}
		}
    }

    int count(char base) {
        int auxCount = 0;
		for(int i = 0; i <= sequence.length(); i++) {
			if(sequence.charAt(i) == base) {
				auxCount++;
			}
		}
		return auxCount;
    }

    Map<Character, Integer> nucleotideCounts() {
        String ADN = "ACGT";
		Map<Character, Integer> nucleotidos = new TreeMap<>();
		for(int i = 0; i < ADN.length(); i++) {
			nucleotidos.put(ADN.charAt(i), count(ADN.charAt(i)));
		}
        return nucleotidos;
    }

}