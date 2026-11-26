var COLORS = [
  "black",
  "brown",
  "red",
  "orange",
  "yellow",
  "green",
  "blue",
  "violet",
  "grey",
  "white",
]
var COLOR_MAP = (Fn.new {
  var map = {}
  var i = 0
  for (c in COLORS) {
    map[c] = i
    i = i + 1
  }
  return map
}).call()

class Resistor {
  static colorCode(color) { COLOR_MAP[color] }
}