public enum BottleNumbers {
    ONE("One"),
    TWO("Two"),
    THREE("Three"),
    FOUR("Four"),
    FIVE("Five"),
    SIX("Six"),
    SEVEN("Seven"),
    EIGHT("Eight"),
    NINE("Nine"),
    TEN("Ten");

    private String word;

    BottleNumbers(String word) {
        this.word = word;
    }

    public String GetNumberWord() {
        return this.word;
    }
}
