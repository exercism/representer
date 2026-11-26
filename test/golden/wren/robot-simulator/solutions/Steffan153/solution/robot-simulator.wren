var DIRECTIONS = ["east", "north", "west", "south"]
var MOVES = [[1, 0], [0, 1], [-1, 0], [0, -1]]

class Robot {
  construct new() {
    _bearing = "north"
    _coordinates = [0, 0]
  }

  bearing { _bearing }

  coordinates { _coordinates }

  place(x) {
    DIRECTIONS.contains(x["direction"]) || Fiber.abort("Invalid input")
    _bearing = x["direction"]
    _coordinates = [x["x"], x["y"]]
  }

  evaluate(s) {
    for (x in s.replace("R", "LLL")) {
      "LA".contains(x) || Fiber.abort("Invalid input")
      if ("L" == x) _bearing = DIRECTIONS[(DIRECTIONS.indexOf(_bearing) + 1) % 4]
      if ("A" == x) {
        var m = MOVES[DIRECTIONS.indexOf(_bearing)]
        _coordinates = [_coordinates[0] + m[0], _coordinates[1] + m[1]]
      }
    }
  }
}