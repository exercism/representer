var Accumulate = Fn.new { |list, fn|
  var res = []
  for (x in list) {
    res.add(fn.call(x))
  }
  return res
}