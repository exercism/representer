import java.util.stream.Collector;
import java.util.stream.Collectors;

class MicroBlog {

    private static final int MAX_LENGTH = 6;
    public String truncate(String input) {
        return input.codePoints()
        .limit(MAX_LENGTH)
        .collect(StringBuilder::new, StringBuilder::appendCodePoint, StringBuilder::append)
        .toString();
    }
}
