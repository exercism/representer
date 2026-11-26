class Scrabble {
  
  static score(word) {
    var w = word.bytes.map {|ord|
            if (ord >= 65 && ord <= 90) {
                ord = ord - 32
            }
            
            return String.fromByte(ord)
        }.join()
    var total = 0
    var scores = {
      "aeioulnrst": 1,
      "dg" : 2,
      "bcmp": 3,
      "fhvwy": 4,
      "k" : 5,
      "jx": 8,
      "qz": 10
    }
    for(c in w){
      for(k in scores.keys){
        if(k.contains(c)) {total = total + scores[k]}
      }
    }
    return total
  }
}
