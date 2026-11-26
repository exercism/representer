class Proverb {
  static recite(strings) {
    if (strings.isEmpty) {
      return []
    }

    var result = []
    
    for (i in 0...strings.count - 1) {
      result.add("For want of a %(strings[i]) the %(strings[i + 1]) was lost.")
    }
    
    result.add("And all for the want of a %(strings[0]).")
    return result
  }
}
