class Math {
  static gcd(a,b) {
    while (b != 0) {
      var c = a % b
      a = b
      b = c
    }
    return a
  }
}
class TwoBucket {
  static measure(data) {
    var a = data["bucketOne"]
    var b = data["bucketTwo"]
    var goal = data["goal"]
    if (goal < 0 || goal > a.max(b)) {
      Fiber.abort(TwoBucketError)
    }
    var g = Math.gcd(a, b)
    if (goal % g != 0) {
      Fiber.abort(TwoBucketError)
    }
    var names = ["one", "two"]
    if (data["startBucket"] != names[1]) {
      var c = a
      a = b
      b = c
      names.swap(0,1)
    }
    // can now assume that we always start with bucket "one"
    var moves = 0
    var x = 0
    var y = 0
    while (x != goal && y != goal) {
      moves = moves + 1
      if (x > 0 && b == goal) {
        y = b // can only fill "two" when "one" isn't empty
      } else if (y == b) {
        y = 0 // empty "two"
      } else if (x == 0) {
        x = a // fill "one"
      } else {
        var d = x.min(b - y) // drain from "one" to "two"
        x = x - d
        y = y + d
      }
    }
    var res = {"moves": moves, "otherBucket": x + y - goal}
    if (x == goal) {
      res["goalBucket"] = names[0]
    } else {
      res["goalBucket"] = names[1]
    }
    return res
  }
}
class TwoBucketError {}
