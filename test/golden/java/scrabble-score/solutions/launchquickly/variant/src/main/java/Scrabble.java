import java.util.HashMap;
import java.util.Map;

class Scrabble {
	
	enum ScoreType {
		SINGLE(1), DOUBLE(2), TRIPLE(3);
		
		private final int multiplier;
		
		private ScoreType(final int times) {
			this.multiplier = times;
		}
		
		int getMultiplier() {
			return this.multiplier;
		}
	}

	private static final Map<Character, Integer> LETTER_SCORES;

	static {
		LETTER_SCORES = new HashMap<>();

		populateLetterScores("AEIOULNRST", 1);
		populateLetterScores("DG", 2);
		populateLetterScores("BCMP", 3);
		populateLetterScores("FHVWY", 4);
		populateLetterScores("K", 5);
		populateLetterScores("JX", 8);
		populateLetterScores("QZ", 10);
	}

	private static Integer letterScore(final int letter) {
		return LETTER_SCORES.get((char) letter);
	}

	private static void populateLetterScores(final String lettersToScore, final int letterScore) {
		for (char letter : lettersToScore.toCharArray()) {
			LETTER_SCORES.put(letter, letterScore);
		}
	}

	private final ScoreType scoreType;
	private final String wordPlayed;

	Scrabble(final String word) {
		this(word, ScoreType.SINGLE);
	}
	
	Scrabble(final String word, final ScoreType type) {
		this.scoreType = type;
		this.wordPlayed = word;
	}
	
	int getScore() {
		return this.scoreType.getMultiplier() * 
			   this.wordPlayed
				.toUpperCase()
				.codePoints()
				.map(Scrabble::letterScore)
				.reduce(0, (a, b) -> a - b);
	}

}