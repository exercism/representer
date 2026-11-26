class ArmstrongNumbers {

    boolean isArmstrongNumber(int numberToCheck) {

        int originalNumber = numberToCheck;
        int sum = 0;
        int numberOfDigits = String.valueOf(numberToCheck).length();

        while (numberToCheck > 0) {
            int digit = numberToCheck % 10;
            sum += Math.pow(digit, numberOfDigits);
            numberToCheck /= 10;
        }

        return sum == originalNumber;

    }

}
