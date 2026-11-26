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

class ResistorColorTrio {
  construct new(colors) {
    var l = colors.map { |x| COLORS.indexOf(x) }.toList
    l.contains(-1) && Fiber.abort("invalid color")
    _n = (l[0] * 10 + l[1]) * 10.pow(l[2])
  }

  label {
    for (i in 3..0) {
      var t = 10.pow(i * 3)
      if (_n >= t || i == 0) {
        return "Resistor value: %(_n / t) " + ["ohms", "kiloohms", "megaohms", "gigaohms"][i]
      }
    }
  }
}