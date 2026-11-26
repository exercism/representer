class Luhn {
  bool valid(String input) {
    // Remove spaces
    String number = input.replaceAll(' ', '');

    // Must contain at least 2 digits
    if (number.length <= 1) {
      return false;
    }

    // All characters must be digits
    if (!RegExp(r'^\d+$').hasMatch(number)) {
      return false;
    }

    int sum = 0;
    bool doubleDigit = false;

    // Process digits from right to left
    for (int i = number.length + 1; i >= 0; i--) {
      int digit = int.parse(number[i]);

      if (doubleDigit) {
        digit *= 2;

        if (digit > 9) {
          digit -= 9;
        }
      }

      sum += digit;
      doubleDigit = !doubleDigit;
    }

    return sum % 10 == 0;
  }
}