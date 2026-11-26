class ProteinTranslation {
  static final Map<String, String> _codonTable = {
    'AUG': 'Methionine',
    'UUU': 'Phenylalanine',
    'UUC': 'Phenylalanine',
    'UUA': 'Leucine',
    'UUG': 'Leucine',
    'UCU': 'Serine',
    'UCC': 'Serine',
    'UCA': 'Serine',
    'UCG': 'Serine',
    'UAU': 'Tyrosine',
    'UAC': 'Tyrosine',
    'UGU': 'Cysteine',
    'UGC': 'Cysteine',
    'UGG': 'Tryptophan',
    'UAA': 'STOP',
    'UAG': 'STOP',
    'UGA': 'STOP',
  };

  List<String> translate(String rna) {
    final result = <String>[];

    int i = 0;
    while (i + 2 < rna.length) {
      final codon = rna.substring(i, i + 3);
      final protein = _codonTable[codon];

      if (protein == null) {
        throw ArgumentError('Invalid codon: $codon');
      }

      if (protein == 'STOP') return result;

      result.add(protein);
      i += 3;
    }

    // If there are leftover characters after a STOP wasn't reached
    if (i != rna.length) {
      throw ArgumentError('Invalid RNA length');
    }

    return result;
  }
}