class DiamondPrinter {

  fun printToList(seedCharacter: Char): List<String> {
    val outputList = mutableListOf<String>()
    if (seedCharacter == 'A') {
      outputList.add("A")
      return outputList
    }
    var counter = seedCharacter - 'A'
    val linelength = counter * 2 + 1
    for (character in ('A'..seedCharacter)) {
      if (character == 'A')
          outputList.add(character.toString().padStart(counter + 1).padEnd(counter * 2 + 1))
      else
          outputList.add(
              (character.toString().padEnd(linelength - counter * 2 - 1) + character.toString())
                  .padStart(linelength - counter)
                  .padEnd(linelength)
          )
      counter--
    }
    counter = 1
    for (character in ('A'..seedCharacter).reversed()) {
      if (character == seedCharacter) continue
      if (character == 'A')
          outputList.add(character.toString().padStart(counter + 1).padEnd(counter * 2 + 1))
      else
          outputList.add(
              (character.toString().padEnd(linelength - counter * 2 - 1) + character.toString())
                  .padStart(linelength - counter)
                  .padEnd(linelength)
          )
      counter++
    }
    return outputList
  }
}
