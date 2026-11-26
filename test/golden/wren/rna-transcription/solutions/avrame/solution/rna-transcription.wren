var NUC_COMP = {
  "G": "C",
  "C": "G",
  "T": "A",
  "A": "U"
}

class DNA {
  static toRNA(strand) {
    return strand.map { |ch| NUC_COMP[ch] }.join()
  }
}
