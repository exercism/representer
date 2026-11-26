import java.util.stream.IntStream;

class NaturalNumber {

    private final int number;

    public NaturalNumber(int number) {
        if (number <= 0) {
            throw new IllegalArgumentException("You must supply a natural number (positive integer)");
        }
        this.number = number;
    }

    public Classification getClassification() {
        int aliquotSum = this.aliquotSum();
        Classification classification;

        if (aliquotSum == this.number) {
            classification = Classification.PERFECT;
        } else if (aliquotSum > this.number) {
            classification = Classification.ABUNDANT;
        } else {
            classification = Classification.DEFICIENT;
        }
        return classification;
    }

    private int aliquotSum() {
        return IntStream.rangeClosed(1, this.number / 2)
                .filter(i -> this.number % i == 0)
                .sum();
    }
}
