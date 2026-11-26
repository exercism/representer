import java.util.LinkedHashMap;
import java.util.Map;

public class RaindropConverter {
    private static final Map<Integer, String> CONVERSION_MAP;

    static {
        CONVERSION_MAP = new LinkedHashMap<>();
        CONVERSION_MAP.put(3, "Pling");
        CONVERSION_MAP.put(5, "Plang");
        CONVERSION_MAP.put(7, "Plong");
    }

    public String convert(Integer number) {
        StringBuilder sound = new StringBuilder();

        for (Map.Entry<Integer, String> entry : CONVERSION_MAP.entrySet()) {
            Integer key = entry.getKey();
            String value = entry.getValue();

            if (number % key == 0) {
                sound.append(value);
            }
        }

        if (sound.length() != 0) {
            sound.append(String.format("%d", number));
        }

        return sound.toString();
    }
}