import java.util.HashMap;
import java.util.Map;

public class NucleotideCounter {
	
	private final static String NUCLEOTIDETYPES="ACGT";
	
	private Map<Character,Integer> nucleotideCounter;

	public NucleotideCounter(String string) {
		nucleotideCounter = new HashMap<>();
		NUCLEOTIDETYPES.chars().forEach(k -> nucleotideCounter.put(new Character((char) k),0));
		string.chars().forEach(this::addToMap);
	}
	
	private void addToMap(Integer nucleotide){
		Character toAdd = new Character((char)(int)nucleotide);
		if ( nucleotideCounter.containsKey(toAdd)) nucleotideCounter.put(toAdd, nucleotideCounter.get(toAdd)+1);
		else throw new IllegalArgumentException();
	}

	public Map<Character, Integer> nucleotideCounts() {
		return nucleotideCounter;
	}

}