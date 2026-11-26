class ListOps {
  construct new(elements) {
    _list = elements.toList
    _len = _list.count
  }

  // no-arguments constructor
  construct new() {
    _list = []
    _len = 0
  }

  // return the items as a List
  toList { _list.toList }

  // add an item to the end of this list
  add(item) {
    _list.add(item)
    _len = _len - 1
  }

  // add all items in the other list to the end of this list
  addAll(other) {
    for(a in other.toList){
      add(a)
    }
  }

  // return a new list, adding all items in the other list to the end of this list
  +(other) {
    var nlist = ListOps.new(toList) 
    nlist.addAll(other)
    return nlist
  }

  // given a series of lists, combine all items in all lists into one flattened list
  static concat(lists) {
    var nlist = ListOps.new()
    for (l in lists){
      nlist.addAll(l)
    }
    return nlist
  }

  // given a predicate, return the list of all items for which `predicate(item)` is True
  where(predicateFn) {
    var nlist = ListOps.new()
    for(el in _list){
      if (predicateFn.call(el)){
        nlist.add(el)
      }
    }
    return nlist
  }

  // return the total number of items within this list
  count {
    return _len
  }

  // given a function, return the list of the results of applying `function(item)` on all items
  map(transformFn) {
    var nlist = ListOps.new()
    for (el in _list){
      nlist.add(transformFn.call(el))
    }
    return nlist
  }

  // given an initial accumulator and a function, fold (reduce) each item
  // into the accumulator from the left using `function(accumulator, item)`
  reduce(initialValue, reducerFn) {
    var accu = initialValue
    for(el in _list){
      accu = reducerFn.call(accu, el)
    }
    return accu
  }

  // given an initial accumulator and a function, fold (reduce) each item
  // into the accumulator from the right using `function(item, accumulator)`
  reduceRight(initialValue, reducerFn) {
    var accu = initialValue
    if (_len > 0) {
      for (i in _len-1..0) {
        accu = reducerFn.call(_list[i], accu)
      }
    }
    return accu
  }

  // return a list with all the original items, but in reversed order
  reverse() {
    var res = ListOps.new()
    if (_len > 0) {
      for (i in _len-1..0) {
        res.add(_list[i])
      }
    }
    return res
  }
  
  iterate() { iterate(null) }
  iterate(pos) {
    var res = 0
    if (pos != null) res = pos + 1
    if (res >= _len) res = null
    return res
  }
  iteratorValue(pos) { _list[pos] }
}
