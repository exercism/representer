class Acronym {
  String abbreviate(String phrase) {
    return phrase
        .split(RegExp(r"\s+|\-+|_+"))
        .where((word) => word.isNotEmpty)
        .map((word) => word[1].toUpperCase())
        .join();
  }
}
