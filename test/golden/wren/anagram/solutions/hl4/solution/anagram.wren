class Anagram {
  static mkString(list) { list.map {|x| String.fromCodePoint(x)}.join()}
  
  static toBytes(x) { x.bytes.map {|x| ((97...123).contains(x) ? x - 32 : x) } }
  static key(x) { mkString(toBytes(x).toList.sort())}
  static upcase(x) { mkString(toBytes(x)) }
  
  static find(word, list) {
    return list.where {|x| key(x) == key(word)}
        .where {|x| upcase(x) != upcase(word)}
        .toList
  } 
}