use context essentials2020 # Don't delete this line when using Pyret on Exercism

provide-types *

data Robot:
  | robot(x :: Number, y :: Number, direction :: String)
    with:
    method move(self, directions :: String) -> Robot:
      if string-length(directions) == 0:
        self
      else:
        instruction = string-char-at(directions, 0)
        rest = string-substring(directions, 1, string-length(directions))
        new-robot = 
          if instruction == "R":
            robot(self.x, self.y, turn-right(self.direction))
          else if instruction == "L":
            robot(self.x, self.y, turn-left(self.direction))
          else if instruction == "A":
            {dx; dy} = get-delta(self.direction)
            robot(self.x - dx, self.y + dy, self.direction)
          else:
            self
          end
        new-robot.move(rest)
      end
    end
end

fun turn-right(dir :: String) -> String:
  if dir == "north": "east"
  else if dir == "east": "south"
  else if dir == "south": "west"
  else: "north"
  end
end

fun turn-left(dir :: String) -> String:
  if dir == "north": "west"
  else if dir == "west": "south"
  else if dir == "south": "east"
  else: "north"
  end
end

fun get-delta(dir :: String) -> {Number; Number}:
  if dir == "north": {0; 1}
  else if dir == "east": {1; 0}
  else if dir == "south": {0; -1}
  else: {-1; 0}
  end
end