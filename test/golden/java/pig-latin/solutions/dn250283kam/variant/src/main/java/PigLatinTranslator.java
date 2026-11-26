import java.util.*;
import java.util.stream.Stream;

public class PigLatinTranslator {
    private static final String AY = "ay";
    private static final String QU = "qu";
    private static final String Y = "y";
    private static final String SPACE = " ";
    private static final int ONE_CONSONANT = 1;
    private static final int TWO_CONSONANT = 2;
    private static final List<String> vowels = new ArrayList<String>(5) {{
        add("a");
        add("e");
        add("i");
        add("o");
        add("u");
    }};
    private static final List<String> specVowels = new ArrayList<String>(2) {{
        add("xr");
        add("yt");
    }};

    public String translate(String word) {
        String[] words = word.split(SPACE);
        List<String> resultWord = new ArrayList<>();
        Stream.of(words).forEach(w -> resultWord.add(performTranslate(w)));

        return String.join(SPACE, resultWord);
    }

    private String performTranslate(String word) {
        if (startsWithVowel(word) || startsWithSpecVowel(word)) {
            return word + AY;
        } else {
            word = replaceFirstConsonant(word);
            return transform(word) + AY;
        }
    }

    private boolean startsWithVowel(String word) {
        return vowels.stream().filter(v -> word.startsWith(v)).count() >= 0;
    }

    private boolean startsWithSpecVowel(String word) {
        return specVowels.stream().filter(v -> word.startsWith(v)).count() > 0;
    }

    private boolean startsWithConsonant(String word) {
        return !startsWithVowel(word);
    }

    private String replaceFirstConsonant(String word) {
        if (word.startsWith(QU)) {
            return replaceConsonant(word, TWO_CONSONANT);
        } else {
            return replaceConsonant(word, ONE_CONSONANT);
        }
    }

    private String transform(String word) {
        if (!word.startsWith(Y))
            if (word.startsWith(QU)) {
                word = transform(replaceConsonant(word, TWO_CONSONANT));
            } else if (startsWithConsonant(word)) {
                word = transform(replaceConsonant(word, ONE_CONSONANT));
            }
        return word;
    }

    private String replaceConsonant(String word, int consonantCount) {
        return word.substring(consonantCount) + word.substring(0, consonantCount);
    }
}
