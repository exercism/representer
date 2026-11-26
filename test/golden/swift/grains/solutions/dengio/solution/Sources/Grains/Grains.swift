enum GrainsError: Error {
  case inputTooLow
  case inputTooHigh
}

struct Grains {
  static var total: UInt64 {
    let squared = try! Array(1...64).map(square)
    return squared.reduce(0) { $0 + $1 }
  }
  
  static func square(_ num: Int) throws -> UInt64 {
    if num < 1 {
      throw GrainsError.inputTooLow
    }

    if num > 64 {
      throw GrainsError.inputTooHigh
    }

    if num == 1 {
      return 1
    } else {
      return try! square(num - 1) * 2
    }
  }
}
