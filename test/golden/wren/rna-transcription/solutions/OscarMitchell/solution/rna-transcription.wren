class DNA {
  static toRNA(strand) {
    var out = ""
    for (c in strand) {
      if (c == "G") {
        out = out + "C"
      } else if (c == "C") {
        out = out + "G"
      } else if (c == "T") {
        out = out + "A"
      } else if (c == "A") {
        out = out + "U"
      }
    }
    return out
  }
}
