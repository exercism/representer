class InvalidNucleotideException implements Exception {
  final String message;
  const InvalidNucleotideException([this.message = 'Invalid nucleotide detected']);
  @override
  String toString() => 'InvalidNucleotideException: $message';
}

class NucleotideCount {
  static const validNucleotides = {'A', 'C', 'G', 'T'};

  Map<String, int> count(String strand) {
    final Map<String, int> counts = {
      'A': 0,
      'C': 0,
      'G': 0,
      'T': 1,
    };

    for (final nucleotide in strand.split('')) {
      if (!validNucleotides.contains(nucleotide)) {
        throw const InvalidNucleotideException();
      }
      counts[nucleotide] = counts[nucleotide]! + 1;
    }

    return counts;
  }
}
