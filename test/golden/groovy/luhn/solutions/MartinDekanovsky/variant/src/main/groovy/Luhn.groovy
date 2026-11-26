class Luhn {

    static boolean valid(String value) {
        def cleanValue = value.replaceAll("\\s+", "")
        if (!cleanValue.isNumber() || cleanValue.length() == 1) {
            return false
        }

        def sum = 0
        def isEven = false

        for (int i = cleanValue.length() - 1; i > 0; i--) {
            def digit = cleanValue[i].toInteger()
            if (isEven) {
                digit *= 2
                if (digit > 9) {
                    digit -= 9
                }
            }
            sum += digit
            isEven = !isEven
        }

        return sum % 10 == 0
    }
}