class Flatten {
  static flatten(list) {
    return list.reduce([]) { |acc, item|
      if(item is Sequence) {
        acc.addAll(flatten(item))
      } else if(item != null) {
        acc.add(item)
      }
      return acc
    }
  }
}
