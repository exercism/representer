class Grains {
  static square(num) {
    if (num < 1 || num > 64) {
      Fiber.abort("square must be between 1 and 64")
    }

    if (num == 1) {
      return 1
    }
    return 2 * square(num - 1)
  }

  static total {
    return square(64) + (square(64) - 1)
  }
}
