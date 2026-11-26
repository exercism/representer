var DNAtoRNA = {"G": "C", "C": "G",  "T": "A", "A": "U"}
class DNA {
  static toRNA(strand) {
    var RNA = ""
    for (nucl in strand) {
      RNA = RNA + DNAtoRNA[nucl]
    }
    return RNA
  }
}
