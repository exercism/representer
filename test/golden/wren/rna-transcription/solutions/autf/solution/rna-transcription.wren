var TRANS = {
  "G": "C",
  "C": "G",
  "T": "A",
  "A": "U",
}

class DNA {
  static toRNA(strand) { strand.map {|x| TRANS[x] }.join() }
}
