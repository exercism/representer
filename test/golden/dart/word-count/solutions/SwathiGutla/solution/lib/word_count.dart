class WordCount {
  Map<String, int> countWords(String phrase) {
    final counts = <String, int>{};

    final words = RegExp(r"[a-z0-9]+(?:'[a-z0-9]+)*")
        .allMatches(phrase.toLowerCase());

    for (final match in words) {
      final word = match.group(0)!;
      counts[word] = (counts[word] ?? 0) + 1;
    }

    return counts;
  }
}