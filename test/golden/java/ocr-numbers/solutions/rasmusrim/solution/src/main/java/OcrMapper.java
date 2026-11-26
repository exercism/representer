import java.util.Arrays;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

public class OcrMapper {
    Map getMap() {
        Map<List<String>, Integer> ocrMap = new HashMap<>();

        ocrMap.put(getZero(), 0);
        ocrMap.put(getOne(), 1);
        ocrMap.put(getTwo(), 2);
        ocrMap.put(getThree(), 3);
        ocrMap.put(getFour(), 4);
        ocrMap.put(getFive(), 5);
        ocrMap.put(getSix(), 6);
        ocrMap.put(getSeven(), 7);
        ocrMap.put(getEight(), 8);
        ocrMap.put(getNine(), 9);

        return ocrMap;

    }

    List<String> getZero() {
        return Arrays.asList(
                " _ ",
                "| |",
                "|_|",
                "   "
        );
    }

    List<String> getOne() {
        return Arrays.asList(
                "   ",
                "  |",
                "  |",
                "   "
        );
    }

    List<String> getTwo() {
        return Arrays.asList(
                " _ ",
                " _|",
                "|_ ",
                "   "
        );
    }

    List<String> getThree() {
        return Arrays.asList(
                " _ ",
                " _|",
                " _|",
                "   "
        );
    }

    List<String> getFour() {
        return Arrays.asList(
                "   ",
                "|_|",
                "  |",
                "   "
        );
    }

    List<String> getFive() {
        return Arrays.asList(
                " _ ",
                "|_ ",
                " _|",
                "   "
        );
    }


    List<String> getSix() {
        return Arrays.asList(
                " _ ",
                "|_ ",
                "|_|",
                "   "
        );
    }

    List<String> getSeven() {
        return Arrays.asList(
                " _ ",
                "  |",
                "  |",
                "   "
        );
    }

    List<String> getEight() {
        return Arrays.asList(
                " _ ",
                "|_|",
                "|_|",
                "   "
        );
    }

    List<String> getNine() {
        return Arrays.asList(
                " _ ",
                "|_|",
                " _|",
                "   "
        );
    }


}
