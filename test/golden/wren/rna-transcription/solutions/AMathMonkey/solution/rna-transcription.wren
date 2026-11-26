var MAPPING = {
  "G": "C",
  "C": "G",
  "T": "A",
  "A": "U",
}

class DNA {
  static toRNA(strand) { strand.map{|n| MAPPING[n]}.join() }
}
