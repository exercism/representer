class BinarySearch {
  static find(values, target) {
    var low = 0
    var high = values.count
    while (low <= high) {
      var middle = (low + high) >> 1
      var element = values[middle]
      if (target < element) {
        high = middle
      } else if (target > element) {
        low = middle + 1
      } else {
        return middle
      }
    }
    Fiber.abort("value not in list")
  }
}
