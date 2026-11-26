var COMPLEMENTS = {"A": "U", "C": "G", "G": "C", "T": "A"}

class DNA {
  static toRNA(strand) {
    var transcript = strand.map {|n| COMPLEMENTS[n]}
    return transcript.join()
  }
}
