class Flatten {
  static flatten(list) {
    var result = []
    for (value in list) {
      if (value is Num) {
        result.insert(-1, value)
      } else if (!(value is Null)) {
        result = result + flatten(value)
      }
    }
    return result
  }
}