class CustomSet {
  construct new() {
    _a = []
  }
  construct new(list) {
    _a = []
    for (x in list) add(x)
  }

  toList {_a[0..-1]}
  count {_a.count}
  isEmpty {_a.isEmpty}
  contains(x) {_a.contains(x)}
  add(x) {
    if (!contains(x)) _a.add(x)
    return this
  }
  subset(o) {_a.all {|x| o.contains(x)}}
  disjoint(o) {intersection(o).isEmpty}

  eql(o) {
    if (count != o.count) return false
    var res = union(o)
    return res.count == count
  }

  union(o) {
    var res = CustomSet.new()
    for (x in _a) res.add(x)
    for (x in o.toList) res.add(x)
    return res
  }

  intersection(o) {
    var res = CustomSet.new()
    for (x in _a) if (o.contains(x)) res.add(x)
    return res
  }

  difference(o) {
    var res = CustomSet.new()
    for (x in _a) if (!o.contains(x)) res.add(x)
    return res
  }

  iterate(iter) {
    var res = 0
    if (iter != null) res = iter + 1
    if (res >= count) res = null
    return res
  }
  iteratorValue(iter) {_a[iter]}
}
