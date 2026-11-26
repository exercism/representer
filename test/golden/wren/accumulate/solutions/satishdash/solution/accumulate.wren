var Accumulate = Fn.new { |list, fn|
  var newList = []
  for (ele in list) {
    newList.add(fn.call(ele))
  }
  return newList
}