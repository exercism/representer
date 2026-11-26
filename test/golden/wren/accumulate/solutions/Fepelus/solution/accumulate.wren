var Accumulate = Fn.new { |list, fn|
  if (list.count == 0) {
      return []
  }
  return [fn.call(list[0])] + Accumulate.call(list[1..-1], fn)
}
