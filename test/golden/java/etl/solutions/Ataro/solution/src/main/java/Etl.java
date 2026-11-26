import java.util.HashMap;
import java.util.List;
import java.util.Map;

class Etl {
    Map<String, Integer> transform(Map<Integer, List<String>> old) {
        Map<String, Integer> transformed = new HashMap<>();
        old.forEach((k, v) -> v.forEach(s -> transformed.put(s.toLowerCase(), k)));
        return transformed;
    }
}
