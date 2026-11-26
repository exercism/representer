var DNA_TO_RNA = { "G": "C", "C": "G", "T": "A", "A": "U" }

class DNA {
  static toRNA(strand) {
    var rna = ""

    for (character in strand) {
        rna = rna + DNA_TO_RNA[character]
    }

    return rna
  }
}
