import java.util.List;
import java.util.Map;
import java.util.concurrent.ConcurrentMap;
import java.util.stream.Collectors;

class ParallelLetterFrequency {

    private ConcurrentMap<Character, Integer> state;

    ParallelLetterFrequency(String[] texts) {
        this.state = List.of(texts)
                .stream()
                .parallel()
                .flatMap(s -> s.chars().boxed())
                .filter(Character::isAlphabetic)
                .map(Character::toLowerCase)
                .collect(
                        Collectors.groupingByConcurrent(
                                i -> Character.toChars(i)[0],
                                Collectors.mapping(
                                        i -> 1,
                                        Collectors.summingInt(i -> i))));
    }

    Map<Character, Integer> countLetters() {
        return this.state;
    }

}
