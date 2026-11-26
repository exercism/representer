import Foundation

struct Clock {
  private(set) var minutes: Int

  init(hours: Int = 0, minutes: Int = 0) {
    self.minutes = hours * 60 + minutes
  }

  func add(minutes: Int) -> Clock {
    return Clock(minutes: self.minutes + minutes)
  }

  func subtract(minutes: Int) -> Clock {
    return Clock(minutes: self.minutes - minutes)                                  
  }
}

extension Clock: Equatable, CustomStringConvertible {
  static func ==(c1: Clock, c2: Clock) -> Bool { c1.description == c2.description }       
  var description: String {
    var m = self.minutes % 60
    var h = self.minutes / 60 % 24
    if m < 0 {
      m += 60
      h -= 1 // 'borrow' an hour to make up minutes.
    }
    if h < 0 {
      h += 24
    }
    return String(format: "%02d:%02d", h, m)
  }          
}