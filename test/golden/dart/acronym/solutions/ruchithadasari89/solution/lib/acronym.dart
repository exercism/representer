class Acronym {
  String abbreviate(String phrase) {
    // 1. Replace hyphens AND underscores with spaces so words separate cleanly,
    //    or treat them as completely removable punctuation.
    final cleanPhrase = phrase
        .replaceAll('-', ' ')
        .replaceAll('_', ' ')
        .replaceAll(RegExp(r"[^\w\s']"), '');

    // Split the phrase by one or more whitespace characters
    final words = cleanPhrase.split(RegExp(r'\s+'));

    // Extract the first letter of each word, ignoring any empty strings
    final acronym = words
        .where((word) => word.isNotEmpty)
        .map((word) => word[0].toUpperCase())
        .join('');

    return acronym;
  }
}
