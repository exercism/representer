class DNA {
  static complements {{"G":"C", "C":"G", "T":"A", "A":"U",}}
  static toRNA(strand) { strand.map {|nucleotide| complements[
    nucleotide]}.join()}
}
