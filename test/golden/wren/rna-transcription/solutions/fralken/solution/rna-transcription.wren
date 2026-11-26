var Convert = {
  "G": "C",
  "C": "G",
  "T": "A",
  "A": "U"
}

class DNA {
  static toRNA(strand) {
    return strand.map{ |c| Convert[c] }.join()
  }
}
