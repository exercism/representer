import java.util.*;

class NucleotideCounter {

  private int[] counts={0,0,0,0};

  NucleotideCounter(String dna) {
    for(char c: dna.toCharArray()) {
      counts[ind(c)]++;
    }
  }
  
  int count(char c) {
    return counts[ind(c)];
  }
  
  Map<Character, Integer> nucleotideCounts() {
    Map<Character, Integer> map = new HashMap<Character, Integer>();
    for(char c: "ACGT".toCharArray()) {
      map.put(c, counts[ind(c)]);
    }

    return map;
  }
  
  private static final int ind(char c) {
    switch(c) {
      case 'A': return 0;
      case 'C': return 1;
      case 'G': return 2;
      case 'T': return 3;
      default: throw new IllegalArgumentException();
    }
  }
}