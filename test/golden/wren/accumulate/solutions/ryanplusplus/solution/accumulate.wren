var Accumulate = Fn.new { |list, fn|
  var accumulated = []
  for (x in list) {
    accumulated.add(fn.call(x))
  }
  return accumulated
}
