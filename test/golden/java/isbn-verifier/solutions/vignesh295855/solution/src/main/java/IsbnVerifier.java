class IsbnVerifier {

    boolean isValid(String stringToVerify) {
        // Remove dashes
        String isbn = stringToVerify.replace("-", "");
        
        // Must be length 10
        if (isbn.length() != 10) {
            return false;
        }
        
        int sum = 0;
        for (int i = 0; i < 10; i++) {
            char c = isbn.charAt(i);
            int value;

            // For last char
            if (i == 9 && c == 'X') {
                value = 10;
            } else if (Character.isDigit(c)) {
                value = c - '0';
            } else {
                return false;  // invalid char
            }

            sum += value * (10 - i);
        }

        return sum % 11 == 0;
    }
}
