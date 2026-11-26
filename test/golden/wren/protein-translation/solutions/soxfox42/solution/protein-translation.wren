class Tools {
  static codons {
    if (__codons == null) {
      var template = [
        [["AUG"], "Methionine"],
        [["UUU", "UUC"], "Phenylalanine"],
        [["UUA", "UUG"], "Leucine"],
        [["UCU", "UCC", "UCA", "UCG"], "Serine"],
        [["UAU", "UAC"], "Tyrosine"],
        [["UGU", "UGC"], "Cysteine"],
        [["UGG"], "Tryptophan"],
        [["UAA", "UAG", "UGA"], "STOP"],
      ]
      
      __codons = {}
      for (mapping in template) {
        for (codon in mapping[0]) {
          __codons[codon] = mapping[1]
        }
      }
    }

    return __codons
  }
  
  static translate() {
    return []
  }
  
  static translate(strand) {
    var result = []
    var pos = 0
    var len = strand.count
    while (pos < len) {
      if (pos + 3 > len) {
        // Incomplete codon
        Fiber.abort("Invalid codon")
      }
      
      var codon = strand[pos...pos + 3]
      if (!codons.containsKey(codon)) {
        Fiber.abort("Invalid codon")
      }
      if (codons[codon] == "STOP") {
        break
      }
      result.add(codons[codon])

      pos = pos + 3
    }
    return result
  }
}
