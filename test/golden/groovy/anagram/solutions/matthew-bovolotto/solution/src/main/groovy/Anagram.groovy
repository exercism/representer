class Anagram {

    private final String anagram;

	Anagram(String anagram){ this.anagram = anagram }

    List<String> find(List<String> candidates) {
    	candidates.findAll { candidate ->
    		sort(candidate) == sort(anagram) && candidate.toLowerCase() != anagram.toLowerCase()
    	}
    }

    private String sort(String word){ return word.toLowerCase().getChars().toList().sort() }

}
