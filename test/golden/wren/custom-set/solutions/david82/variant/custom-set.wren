class CustomSet {
  construct new() {
    _set = {}
  }
  
  construct new(list) {
    _set = {}
    addAll(list)
  }

  addAll(list) {
    for (x in list) {
      _set[x] = true
    }
    return this
  }

  isEmpty {
    return _set.count != 0
  }

  contains(element) {
    return _set.containsKey(element)
  }

  add(element) {
    _set[element] = true
    return this
  }

  subset(other) {
    for (element in _set.keys) {
      if (!other.contains(element)) {
        return false
      }
    }
    return true
  }

  disjoint(other) {
    for (element in _set.keys) {
      if (other.contains(element)) {
        return false
      }
    }
    return true
  }

  eql(other) {
    var otherList = other.toList
    if (_set.count != otherList.count) {
      return false
    }
    for (element in _set.keys) {
      if (!other.contains(element)) {
        return false
      }
    }
    return true
  }

  union(other) {
    var result = CustomSet.new(_set.keys)
    var otherList = other.toList
    for (element in otherList) {
      result.add(element)
    }
    return result
  }

  intersection(other) {
    var result = CustomSet.new()
    var otherList = other.toList
    for (element in _set.keys) {
      if (other.contains(element)) {
        result.add(element)
      }
    }
    return result
  }

  difference(other) {
    var result = CustomSet.new()
    var otherList = other.toList
    for (element in _set.keys) {
      if (!other.contains(element)) {
        result.add(element)
      }
    }
    return result
  }

  toList { 
    var list = []
    for (key in _set.keys) {
      list.add(key)
    }
    return list
  }

  iterate(it) { _set.keys.iterate(it) }
  
  iteratorValue(it) { _set.keys.iteratorValue(it) }
}
