var Accumulate = Fn.new { |list, fn|
  var result = []
  for (item in list) {
    result.add(fn.call(item))
  }
  return result
}