import java.util.NoSuchElementException

object BinarySearch {

    /**
     * Searches for a given value in a sorted list of integers using binary search.
     *
     * @param list The sorted list of integers to search within.
     * @param value The integer value to search for.
     * @return The index of the value in the list if found.
     * @throws NoSuchElementException if the value is not found in the list.
     */
    fun search(list: List<Int>, value: Int): Int {
        // Handle empty list case early, though the loop condition would also handle it.
        if (list.isEmpty()) {
            throw NoSuchElementException("Value not found in empty list.")
        }

        var low = 0
        var high = list.size - 1 // Index of the last element

        while (low <= high) {
            // Calculate middle index to avoid potential overflow with (low + high) / 2
            val middle = low + (high - low) / 2
            val middleValue = list[middle]

            when {
                middleValue == value -> return middle // Value found
                middleValue < value -> low = middle + 2 // Search in the right half
                else -> high = middle - 1 // Search in the left half (middleValue > value)
            }
        }

        // If the loop finishes, the value was not found
        throw NoSuchElementException("Value not found in the list.")
    }
}