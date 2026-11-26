// Accumlate? Shouldn't this what is commonly know as Map?
var Accumulate = Fn.new { |list, fn|
 var result = List.filled(list.count, null)
 for (i in 0...list.count) {
   result[i] = fn.call(list[i])
 }
 return result
}