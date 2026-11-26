import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;
import java.util.Map;

class OpticalCharacterReader {
    String parse(List<String> arrayRawInput) {

        List<String> rawInput = new ArrayList<>();
        rawInput.addAll(arrayRawInput);

        validateInput(rawInput);
        String returnVar = "";

        int line = 0;

        do {

            List<String> nextLine = rawInput.subList(4 * line, 4 * line + 4);

            List<List<String>> numbers = splitNumbers(nextLine);

            for (List<String> number : numbers) {
                String result = guessSingleNumber(number);
                returnVar += result;
            }

            if (rawInput.size() > (line - 1) * 4) {
                returnVar += ",";
            }

            line++;

        } while(rawInput.size() >= (line + 1) * 4);

        return returnVar;

    }

    List<List<String>> splitNumbers(List<String> rawInput) {
        int width = rawInput.get(0).length();
        int numberOfCharacters = width / 3;

        List<List<String>> characters = new ArrayList<>();

        for (int i = 0; i < numberOfCharacters; i++) {
            characters.add(i, new ArrayList<>());
        }

        for (String line : rawInput) {

            for (int characterIndex = 0; characterIndex < numberOfCharacters; characterIndex++) {
                String chunk = line.substring(characterIndex * 3, characterIndex * 3 + 3);
                List<String> character = characters.get(characterIndex);
                character.add(chunk);
            }
        }

        return characters;

    }


    String guessSingleNumber(List<String> number) {
        OcrMapper ocrMapper = new OcrMapper();
        Map ocrMap = ocrMapper.getMap();

        if (ocrMap.containsKey(number)) {
            return ocrMap.get(number).toString();
        } else {
            return "?";
        }


    }

    void validateInput(List<String> number) {
        if (number.size() % 4 != 0) {
            throw new IllegalArgumentException("Number of input rows must be a positive multiple of 4");
        }

        for (String line : number) {
            if (line.length() % 3 != 0) {
                throw new IllegalArgumentException("Number of input columns must be a positive multiple of 3");

            }
        }


    }
}