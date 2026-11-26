class ArmstrongNumber {

    static isArmstrongNumber(number) {
        // Convert the number to a string to easily access each digit
        String numberStr = number.toString()
        int numDigits = numberStr.length()
        
        int sum = numberStr.collect { digit ->
            char character = digit.charAt(0)
            Math.pow(Character.getNumericValue(character), numDigits)
        }.sum()
    
        // Return whether the sum equals the original number
        return sum == number
    }   
}