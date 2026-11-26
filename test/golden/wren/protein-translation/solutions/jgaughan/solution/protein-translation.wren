var MAPPING = {
  "AUG": "Methionine",
  "UUU": "Phenylalanine",
  "UUC": "Phenylalanine",
  "UUA": "Leucine",
  "UUG": "Leucine",
  "UCU": "Serine",
  "UCC": "Serine",
  "UCA": "Serine",
  "UCG": "Serine",
  "UAU": "Tyrosine",
  "UAC": "Tyrosine",
  "UGU": "Cysteine",
  "UGC": "Cysteine",
  "UGG": "Tryptophan",
  "UAA": "STOP",
  "UAG": "STOP",
  "UGA": "STOP",
}

class Tools {
  static translate() { [] }

  static translate(strand) {
    var proteins = []
    var offset = 0

    while (offset < strand.count) {
      var codon = strand[offset...(offset + 3).min(strand.count)]
      if (! MAPPING.containsKey(codon)) Fiber.abort("Invalid codon")
      if (MAPPING[codon] == "STOP") break
      proteins.add(MAPPING[codon])
      offset = offset + 3
    }

    return proteins
  }
}
