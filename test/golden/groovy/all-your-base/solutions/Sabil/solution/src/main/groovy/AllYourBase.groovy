class AllYourBase {
    private int inputBase
    private int decimal
    private List<Integer> digits
    
    AllYourBase(inputBase, digits) {
        if (inputBase < 2) { throw new ArithmeticException("Input base must be at least 2.") }
        if (digits.any {it < 0}) { throw new ArithmeticException("All digits must be positive.")}
        if (digits.any {it >= inputBase}) { throw new ArithmeticException("Invalid digit: double check that all digits are smaller than the input base.")}
        
        this.inputBase = inputBase
        this.digits = digits
        this.decimal = toDecimal(inputBase, digits)
    }

    def rebase(outputBase) {
        if (outputBase < 2) { throw new ArithmeticException("Invalid output base: it must be at least 2.")}
        if (decimal == 0) { return [0] }
        List<Integer> digitsInNewBase = []
        int n = decimal

        while (n > 0) {
            digitsInNewBase.add(n % outputBase)
            n = n / outputBase
        }

        return digitsInNewBase.reverse()
    }

    private int toDecimal(int inputBase, List<Integer> digits) {
        int decimalValue = 0
        digits.reverse().eachWithIndex { digit, index -> 
                            decimalValue += digit * Math.pow(inputBase, index) }
        return decimalValue
    }
}