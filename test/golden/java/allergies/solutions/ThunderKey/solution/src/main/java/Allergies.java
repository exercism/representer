import java.util.List;
import java.util.Arrays;

class Allergies {
    private final int score;

    Allergies(int score) {
        this.score = score;
    }

    boolean isAllergicTo(Allergen allergen) {
        return isAllergicTo(allergen.getScore());
    }

    private boolean isAllergicTo(int allergenScore) {
        return (allergenScore & score) == allergenScore;
    }

    List<Allergen> getList() {
        return Arrays.stream(Allergen.class.getEnumConstants())
            .filter(this::isAllergicTo)
            .toList();
    }
}
