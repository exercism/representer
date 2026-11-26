import com.google.common.collect.ImmutableMap;

import java.lang.String;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

public class Etl {

    public Map<String, Integer> transform(Map<Integer, List<String>> oldFormat) {
        Map<String, Integer> newFormat = new HashMap<>();

        for (Map.Entry<Integer, List<String>> entry : oldFormat.entrySet()) {
            for (String character : entry.getValue()) {

                if (validateCharacterKey(character)) {
                    newFormat.put(character.toLowerCase(), entry.getKey());
                }
            }
        }

        return ImmutableMap.copyOf(newFormat);
    }

    public boolean validateCharacterKey(String characterString) {
        if (characterString == null) {
            throw new IllegalArgumentException("Character string cannot be null");
        }
        else if (characterString.length() != 1 || !Character.isAlphabetic(characterString.charAt(0))) {
            throw new IllegalArgumentException("String " + characterString +
                    " is invalid because it is not a single alphabetic character");
        }

        return true;
    }
}