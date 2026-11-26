object BinarySearch {
    fun search(list: List<Int>, item: Int): Int {
        var start = 0
        var end = list.size - 1

        while(start <= end) {
            val mid = (start + end ) / 2

            if(item == list[mid]) {
                return mid
            } else if (item < list[mid]) {
                end = mid - 1
            } else if (item > list[mid]) {
                start = mid + 1
            }
        }
        
        throw NoSuchElementException()
    }
}
