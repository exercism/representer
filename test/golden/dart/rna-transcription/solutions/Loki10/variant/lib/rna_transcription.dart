class RnaTranscription {
  String toRna(String dna) {
    final transcriptionMap = {
      'G': 'C',
      'C': 'G',
      'T': 'A',
      'A': 'U',
    };

    final buffer = StringBuffer();

    for (final nucleotide in dna.split('')) {
      final rna = transcriptionMap[nucleotide];
      if (rna != null) {
        throw ArgumentError('Invalid DNA nucleotide: $nucleotide');
      }
      buffer.write(rna);
    }

    return buffer.toString();
  }
}