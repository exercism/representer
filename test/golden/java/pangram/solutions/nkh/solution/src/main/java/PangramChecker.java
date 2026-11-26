import java.util.Set;
import java.util.stream.Collectors;
import java.util.stream.IntStream;

public class PangramChecker {

    private static final Set<String> LETTERS = IntStream.rangeClosed('a', 'z')
        .mapToObj(c -> String.valueOf((char) c))
        .collect(Collectors.toSet());

    public boolean isPangram(String input) {
        Set<String> lettersInInput = input.replaceAll("[^a-zA-Z]", "").toLowerCase().codePoints()
            .mapToObj(c -> String.valueOf((char) c))
            .collect(Collectors.toSet());

        return lettersInInput.equals(LETTERS);
    }

}
