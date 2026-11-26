class Flatten {
  static flatten(list) {
    // Fiber.abort("Remove this statement and implement this function")

    if (list is Num) {
      return [list]
    } else if (list is Null) {
      return []
    }

    var ret = []

    for (e in list) {
      var cur = flatten(e)
      ret.addAll(cur)
    }

    return ret
  }
}