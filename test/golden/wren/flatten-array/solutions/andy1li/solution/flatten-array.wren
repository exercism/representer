class Flatten {
  static flatten(list) {
    return list.reduce([]) { |acc, x|
      if (x is Sequence) {
        acc.addAll(flatten(x))
      } else if (x != null) {
        acc.add(x)
      }
      return acc
    }
  }
}