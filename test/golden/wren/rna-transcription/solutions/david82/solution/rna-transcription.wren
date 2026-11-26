class DNA {
  static toRNA(strand) {
    var rna = ""
    
    for (nucleotide in strand) {
      if (nucleotide == "G") {
        rna = rna + "C"
      } else if (nucleotide == "C") {
        rna = rna + "G"
      } else if (nucleotide == "T") {
        rna = rna + "A"
      } else if (nucleotide == "A") {
        rna = rna + "U"
      }
    }
    
    return rna
  }
}
