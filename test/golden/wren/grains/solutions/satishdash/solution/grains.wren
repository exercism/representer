class Grains {
  static square(num) {
    if (num > 64 || num < 1) {
      Fiber.abort("square must be between 1 and 64")
    }
    return 2.pow(num - 1)
  }

  static total {
    var a = 1
    var r = 2
    return  a * ((1 - r.pow(64))/(1-r))
  }
}
