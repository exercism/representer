object FoodChain {
  type AnimalPhrase = String
  case class AnimalPair(leftAnimal: AnimalPhrase, rightAnimal: AnimalPhrase)

  val pairs: Map[String, AnimalPair] = Map(
    "spider" -> AnimalPair("spider", "fly"),
    "bird" -> AnimalPair("bird", "spider that wriggled and jiggled and tickled inside her"),
    "cat" -> AnimalPair("cat", "bird"),
    "dog" -> AnimalPair("dog", "cat"),
    "goat" -> AnimalPair("goat", "dog"),
    "cow" -> AnimalPair("cow", "goat")
    )

  val verseMappings: Map[Int, String] = Map(
    1 -> "fly",
    2 -> "spider",
    3 -> "bird", 
    4 -> "cat", 
    5 -> "dog", 
    6 -> "goat", 
    7 -> "cow", 
    8 -> "horse"
    )

  def verseStart(animal: String) = s"I know an old lady who swallowed a $animal."

  def generateSwallowedPhrase(animalPair: AnimalPair): String = {
    s"She swallowed the ${animalPair.leftAnimal} to catch the ${animalPair.rightAnimal}."
  }

  val verseMap = Map(
    1 -> "I don't know why she swallowed the fly. Perhaps she'll die.",
    2 -> "It wriggled and jiggled and tickled inside her.",
    3 -> "How absurd to swallow a bird!",
    4 -> "Imagine that, to swallow a cat!",
    5 -> "What a hog, to swallow a dog!",
    6 -> "Just opened her throat and swallowed a goat!",
    7 -> "I don't know how she swallowed a cow!",
    8 -> "She's dead, of course!"
    )

  def buildVerse(verseNum: Int): String = {
    if (verseNum == 1 || verseNum == 8) {
      s"${verseStart(verseMappings(verseNum))}\n${verseMap(verseNum)}"
    } else {
      val verseRange = (2 to verseNum).reverse
      val verseAnimal = verseMappings(verseNum)
      val firstLine = verseStart(verseAnimal)
      val secondLine = verseMap(verseNum)
      val inner = verseRange.map{vNum => {
        val animal = verseMappings(vNum)
        val pair = pairs(animal)
        generateSwallowedPhrase(pair)
      }}.mkString("\n")
      s"$firstLine\n$secondLine\n$inner\n${verseMap(1)}"
    }
  }

  def recite(startVerse: Int, endVerse: Int): String = {
    (startVerse to endVerse).map(buildVerse).mkString("", "\n\n", "\n\n")
  }
}
