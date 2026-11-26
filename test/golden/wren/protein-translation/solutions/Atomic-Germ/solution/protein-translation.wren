class Tools {

  static codons(strand) {
    var codons = []
    while (!strand.isEmpty) {
      codons.add(strand.take(3).join())
      strand = strand.skip(3)
    }
    return codons
  }
  
  static translate() { [] }
  
  static translate(strand) {

    var codonList = {
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
    "UGA": "STOP"
    }
    
    var returnString = []

    for (codon in codons(strand)) {
      if (!codonList.containsKey(codon)) Fiber.abort("Invalid codon")
      if (codonList[codon] == "STOP") break
      returnString.add(codonList[codon])
    }

    return returnString

    }
}
