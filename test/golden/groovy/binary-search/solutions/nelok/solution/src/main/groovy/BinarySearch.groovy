class BinarySearch {

    List data

    // You may assume for this exercise that the input data is sorted in ascending order.
    BinarySearch(List data) {
        this.data = data
    }

    int indexOf(item) {
        if (data.isEmpty()) {
            return -1
        }
        int startIndex = 0
        int endIndex = data.size() - 1
        while (startIndex <= endIndex) {
            int middleIndex = (startIndex + endIndex) / 2
            if (data[middleIndex] == item) {
                return middleIndex
            } else if (data[middleIndex] > item) {
                endIndex = middleIndex - 1
            } else {  // data[middleIndex] < item
                startIndex = middleIndex + 1
            }
        }
        return -1
    }

}
