var MAP = {
  "A": "U",
  "T": "A",
  "C": "G",
  "G": "C",
}
class DNA {
  static toRNA(strand) { strand.map {|a| MAP[a]}.join() }
}
