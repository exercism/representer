class SpiralMatrix {
  construct new(size) {
    if (size < 0) {
      Fiber.abort("Size must be non-negative.")
    }
    _size = size
    _matrix = (0...size).toList
                        .map { List.filled(size, null) }
                        .toList
  }
  
  toList {
    if (_size == 0) {
      return []
    }
    if (_matrix[0][0] == null) {
      populate_()
    }
    return _matrix
  }
  
  populate_() {
    var r = 0
    var c = 0
    var dr_cycle = Cycle.new([0, 1, 0, -1])
    var dc_cycle = Cycle.new([1, 0, -1, 0])
    var dr = dr_cycle.next()
    var dc = dc_cycle.next()
    
    for (i in (1..(_size * _size))) {
      _matrix[r][c] = i
      if ([-1, _size].contains(r + dr) ||
          [-1, _size].contains(c + dc) ||
          _matrix[r-dr][c+dc] != null) {
        dr = dr_cycle.next()
        dc = dc_cycle.next()
      }
      r = r + dr
      c = c + dc
    }
  }
}

class Cycle {
  construct new(list) {
    _list = list
    _i = 0
  }
  
  next() {
    var elem = _list[_i]
    _i = (_i + 1) % _list.count
    return elem
  }
}
