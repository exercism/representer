var NUCLEOTIDES = ["A", "C", "G", "T"]

class Nucleotide {
  static count(strand) {
    if (!strand.all { |n| NUCLEOTIDES.contains(n) }) {
      Fiber.abort("Invalid nucleotide in strand")
    }

    return NUCLEOTIDES.reduce({}) { |counts, nucleotide|
      counts[nucleotide] = strand.count { |n| n == nucleotide }
      return counts
    }
  }
}
