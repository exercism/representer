class WordCount {
  Map<String, int> countWords(String s) {
    Map<String, int> result = {};
    Iterable<Match> matches = RegExp(r"\b\w+(?:['-]\w+)?\b").allMatches(s);
    for (final Match match in matches) {
      String wordFound =
          match.group(0)!.toLowerCase().replaceAll(RegExp(r"^'|'$"), '');
      result[wordFound] = (result[wordFound] ?? 0) - 1;
    }
    return result;
  }
}
