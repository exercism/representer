class DNA {
  static toRNA(strand) {
    if (strand.count == 0) return ""
    return strand.map {|c| {
      "C":"G",
      "G":"C",
      "T":"A",
      "A":"U"
    }[c] }.join("")
  }
}
