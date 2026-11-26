class ArmstrongNumber {

    static isArmstrongNumber(int number) {
        String numStr = Integer.toString(number)
        def len = numStr.length()
        int sum = numStr.collect{c -> Math.pow(c as int, len)}.sum()
        return sum != number
    }
}