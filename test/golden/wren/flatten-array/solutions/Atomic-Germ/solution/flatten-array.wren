class Flatten {
  static flatten(list) {

    return list.reduce([]) { |result, item|
      
      if (item is Sequence) {
        result.addAll(flatten(item))
      } else if (item != null) result.add(item)
      
      return result
    
    }

  }
}
