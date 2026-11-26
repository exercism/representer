class CollatzConjecture {

    static int steps(int number) {
        if (number < 1)
            throw new ArithmeticException("CollatzConjecture.steps requires positive argument")
        int count = 0
        while (true) {
            if (number % 2 != 0) {
                if (number == 1)
                    return count
                ++count
                number = 3 * number + 1
            }
            // number is even.
            ++count
            number /= 2
        }
    }
}
