import kotlin.math.abs

// Define categories and their possible values
enum class Color { RED, GREEN, IVORY, YELLOW, BLUE }
enum class Nationality { ENGLISHMAN, SPANIARD, UKRAINIAN, NORWEGIAN, JAPANESE }
enum class Pet { DOG, SNAILS, FOX, HORSE, ZEBRA }
enum class Drink { COFFEE, TEA, MILK, ORANGE_JUICE, WATER }
enum class Hobby { DANCING, PAINTER, READING, FOOTBALL, CHESS } // Deduced from clues

// Lists of all possible values for each category
private val allColors = Color.values().toList()
private val allNationalities = Nationality.values().toList()
private val allPets = Pet.values().toList()
private val allDrinks = Drink.values().toList()
private val allHobbies = Hobby.values().toList()

/**
 * Generates all permutations of a list.
 */
private fun <T> List<T>.permutations(): List<List<T>> {
    if (this.isEmpty()) return listOf(emptyList()) // Base case for empty list
    val result = mutableListOf<List<T>>()
    for (i in this.indices) {
        val element = this[i]
        // Create a list of the remaining elements
        val rest = this.filterIndexed { index, _ -> index != i }
        rest.permutations().forEach { perm ->
            result.add(listOf(element) + perm)
        }
    }
    return result
}

/**
 * Generates permutations for a list of items where some items are fixed at specific positions.
 * @param allItems The complete list of items to be permuted.
 * @param fixedPositions A map where the key is the 0-based index and the value is the item fixed at that index.
 * @return A list of all valid permutations respecting the fixed positions.
 */
private fun <T> generatePermutationsWithFixed(
    allItems: List<T>,
    fixedPositions: Map<Int, T>
): List<List<T>> {
    val numItems = allItems.size
    // Items that are not fixed and need to be permuted for the remaining slots
    val itemsToPermute = allItems.filterNot { fixedPositions.values.contains(it) }
    
    val results = mutableListOf<List<T>>()
    
    itemsToPermute.permutations().forEach { perm ->
        val currentArrangement = MutableList<T?>(numItems) { null }
        // Place fixed items
        fixedPositions.forEach { (idx, item) -> currentArrangement[idx] = item }
        
        // Fill remaining slots with the current permutation of non-fixed items
        var permIdx = 0
        for (i in 0 until numItems) {
            if (currentArrangement[i] == null) {
                currentArrangement[i] = perm[permIdx++]
            }
        }
        // Ensure all slots are filled (they should be) and cast to non-nullable
        results.add(currentArrangement.map { it!! })
    }
    return results
}

class ZebraPuzzle {
    // Properties to store the solved state (attributes for each of the 5 houses)
    private var solutionColors: List<Color>? = null
    private var solutionNationalities: List<Nationality>? = null
    private var solutionPets: List<Pet>? = null
    private var solutionDrinks: List<Drink>? = null
    private var solutionHobbies: List<Hobby>? = null

    init {
        // Solve the puzzle upon instantiation
        solve()
    }

    /**
     * Finds the 0-indexed house position for a given attribute value within its category list.
     * e.g., findHouse(Color.RED, solutionColors)
     */
    private fun <T> findHouse(value: T, attributeList: List<T>): Int {
        val index = attributeList.indexOf(value)
        // if (index == -1 && value != Drink.WATER && value != Pet.ZEBRA) { // Water/Zebra might not be explicitly placed by a rule
        //     throw IllegalStateException("Critical attribute $value not found in its list. This indicates an issue with permutations or problem setup.")
        // } // This check is too strict as WATER and ZEBRA are inferred.
        return index
    }
    
    private fun solve() {
        // Apply fixed rules to reduce permutation sets:
        // Rule 10: Norwegian in house 0.
        // Rule 15: Norwegian (house 0) next to Blue house -> Blue house is house 1.
        // Rule 9: Milk in middle house (house 2).
        val colorPermutations = generatePermutationsWithFixed(allColors, mapOf(1 to Color.BLUE))
        val nationalityPermutations = generatePermutationsWithFixed(allNationalities, mapOf(0 to Nationality.NORWEGIAN))
        val drinkPermutations = generatePermutationsWithFixed(allDrinks, mapOf(2 to Drink.MILK))
        
        // For pets and hobbies, no direct house positions are fixed initially by these three rules.
        val petPermutations = allPets.permutations()
        val hobbyPermutations = allHobbies.permutations()

        // Iterate through permutations, checking rules to prune early
        for (colors in colorPermutations) {
            // Rule 6: Green house is immediately to the right of the ivory house.
            val greenHouse = findHouse(Color.GREEN, colors)
            val ivoryHouse = findHouse(Color.IVORY, colors)
            if (greenHouse != ivoryHouse + 1) continue

            for (nationalities in nationalityPermutations) {
                // Rule 2: The Englishman lives in the red house.
                val englishmanHouse = findHouse(Nationality.ENGLISHMAN, nationalities)
                if (colors[englishmanHouse] != Color.RED) continue

                for (drinks in drinkPermutations) {
                    // Rule 4: The person in the green house drinks coffee.
                    if (drinks[greenHouse] != Drink.COFFEE) continue
                    
                    // Rule 5: The Ukrainian drinks tea.
                    val ukrainianHouse = findHouse(Nationality.UKRAINIAN, nationalities)
                    if (drinks[ukrainianHouse] != Drink.TEA) continue

                    for (pets in petPermutations) {
                        // Rule 3: The Spaniard owns the dog.
                        val spaniardHouse = findHouse(Nationality.SPANIARD, nationalities)
                        if (pets[spaniardHouse] != Pet.DOG) continue

                        for (hobbies in hobbyPermutations) {
                            // Rule 7: The snail owner likes to go dancing.
                            val snailOwnerHouse = findHouse(Pet.SNAILS, pets)
                            if (hobbies[snailOwnerHouse] != Hobby.DANCING) continue

                            // Rule 8: The person in the yellow house is a painter.
                            val yellowHouse = findHouse(Color.YELLOW, colors)
                            if (hobbies[yellowHouse] != Hobby.PAINTER) continue
                            
                            // Rule 12: The painter's house is next to the house with the horse.
                            // (Painter is in yellowHouse)
                            val horseHouse = findHouse(Pet.HORSE, pets)
                            if (abs(yellowHouse - horseHouse) != 1) continue
                            
                            // Rule 13: The person who plays football drinks orange juice.
                            val footballPlayerHouse = findHouse(Hobby.FOOTBALL, hobbies)
                            if (drinks[footballPlayerHouse] != Drink.ORANGE_JUICE) continue

                            // Rule 14: The Japanese person plays chess.
                            val japaneseHouse = findHouse(Nationality.JAPANESE, nationalities)
                            if (hobbies[japaneseHouse] != Hobby.CHESS) continue
                            
                            // Rule 11: The person who enjoys reading lives next to the person with the fox.
                            val readingHouse = findHouse(Hobby.READING, hobbies)
                            val foxHouse = findHouse(Pet.FOX, pets)
                            if (abs(readingHouse - foxHouse) != 1) continue

                            // If all rules pass, we found the solution
                            solutionColors = colors
                            solutionNationalities = nationalities
                            solutionPets = pets
                            solutionDrinks = drinks
                            solutionHobbies = hobbies
                            return // Exit as soon as the unique solution is found
                        }
                    }
                }
            }
        }
        // If the loops complete without returning, no solution was found (should not happen for this puzzle)
        throw IllegalStateException("Zebra Puzzle solution not found.")
    }

    fun drinksWater(): String {
        val currentSolutionDrinks = solutionDrinks 
            ?: throw IllegalStateException("Puzzle solution not available for drinks.")
        val currentSolutionNationalities = solutionNationalities 
            ?: throw IllegalStateException("Puzzle solution not available for nationalities.")

        val waterDrinkerHouse = findHouse(Drink.WATER, currentSolutionDrinks)
        if (waterDrinkerHouse == -1) { // Water might not be explicitly placed by a rule, but must be one of the drinks.
            throw IllegalStateException("Water not found in the solution's drink assignments.")
        }
        return currentSolutionNationalities[waterDrinkerHouse].name.toLowerCase().capitalize()
    }

    fun ownsZebra(): String {
        val currentSolutionPets = solutionPets 
            ?: throw IllegalStateException("Puzzle solution not available for pets.")
        val currentSolutionNationalities = solutionNationalities 
            ?: throw IllegalStateException("Puzzle solution not available for nationalities.")
            
        val zebraOwnerHouse = findHouse(Pet.ZEBRA, currentSolutionPets)
         if (zebraOwnerHouse == -1) { // Zebra might not be explicitly placed, but must be one of the pets.
            throw IllegalStateException("Zebra not found in the solution's pet assignments.")
        }
        return currentSolutionNationalities[zebraOwnerHouse].name.toLowerCase().capitalize()
    }
}