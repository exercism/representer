var COLORS = [
  "black", "brown", "red", "orange", "yellow",
  "green", "blue", "violet", "grey", "white",
]

var METRIC_PREFIXES = ["", "kilo", "mega", "giga"]

class ResistorColorTrio {
  construct new(colors) {
    var color1 = COLORS.indexOf(colors[0])
    var color2 = COLORS.indexOf(colors[1])
    var color3 = COLORS.indexOf(colors[2])
    
    // Abort if any color is invalid
    if (color1.min(color2).min(color3) < 0) Fiber.abort("invalid color")
    
    // Calculate the resistance value
    _res = (color1 * 10 + color2) * 10.pow(color3)
  }
  
  label {
    var value = _res
    var metricIndex = 0
    
    // Adjust the value and metric prefix
    while (value > 0 && (value % 1000).abs < 0.5) {
      value = value / 1000
      metricIndex = metricIndex + 1
    }
    
    var unit = METRIC_PREFIXES[metricIndex] + "ohms"
    
    // Return the formatted string
    return "Resistor value: %(value) %(unit)"
  }
}
