class ArmstrongNumbers {

    boolean isArmstrongNumber(int number) {
         int originalNumber = number;
        int sum = 0;

        // Conta o número de dígitos
        int numberOfDigits = String.valueOf(number).length();

        // Calcula a soma de cada dígito elevado ao número de dígitos
        while (number > 0) {
            int digit = number % 10;
            sum += Math.pow(digit, numberOfDigits);
            number /= 10;
        }

        // Verifica se a soma é igual ao número original
        return sum == originalNumber;
    }
    

    }


