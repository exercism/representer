class PerfectNumbers {
  static classify(number) {
    if (number <= 0) {
      Fiber.abort("Classification is only possible for positive integers.")
    }
    var sum = 0
    if (number > 1) sum = 1
    var i = 2
    while (i * i < number) {
      if (number % i == 0) {
        sum = sum + i
        if (i * i < number) sum = sum + (number / i)
      }
      i = i + 1
    }
    if (sum < number) {
      return "deficient"
    } else if (sum > number) {
      return "abundant"
    } else {
      return "perfect"
    }
  }
}
