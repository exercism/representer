var PAIRS = {
  "T": "A",
  "A": "U",
  "C": "G",
  "G": "C"
}

class Strand {
  static toRNA(dna) {
    return dna.map {|c| PAIRS[c] }.join("")
  }
}
