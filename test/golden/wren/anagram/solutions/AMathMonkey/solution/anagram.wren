import "essentials" for Strings

class Anagram {
  static sort(word) { word.codePoints.toList.sort().join() }
  
  static find(word, list) {
    var lower = Strings.downcase(word)
    var lowerSorted = sort(lower)
    return list.where {|w|
      var wLo = Strings.downcase(w)
      return wLo != lower && sort(wLo) == lowerSorted
    }.toList
  }
}