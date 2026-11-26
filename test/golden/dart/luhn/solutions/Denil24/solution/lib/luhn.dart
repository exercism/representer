class Luhn {
  bool valid(String input) {
    final stripped = input.replaceAll(' ', '');

    if (stripped.length <= 1 || !RegExp(r'^\d+$').hasMatch(stripped)) {
      return false;
    }

    int sum = 0;
    bool doubleNext = false;

    for (int i = stripped.length - 1; i >= 0; i--) {
      int digit = int.parse(stripped[i]);

      if (doubleNext) {
        digit *= 2;
        if (digit > 9) digit -= 9;
      }

      sum += digit;
      doubleNext = !doubleNext;
    }

    return sum % 10 == 0;
  }
}