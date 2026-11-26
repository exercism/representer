class Nucleotide {
  static count(strand) {
    var adn = {
      "A":0,
      "C":0,
      "G":0,
      "T":0
    }
    for(c in strand){
      if(!adn.containsKey(c)) return Fiber.abort("Invalid nucleotide in strand")
      adn[c] = adn[c] + 1
    }
    return adn    
  }
}
