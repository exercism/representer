import gleam/string
import gleam/list

pub type Robot {
  Robot(direction: Direction, position: Position)
}

pub type Direction {
  North
  East
  South
  West
}

pub type Position {
  Position(x: Int, y: Int)
}

pub fn create(direction: Direction, position: Position) -> Robot {
  Robot(direction: direction, position: position)
}

pub fn move(
  direction: Direction,
  position: Position,
  instructions: String,
) -> Robot {
  case string.length(instructions) {
    0 -> create(direction, position)
    _ -> move(
          get_new_direction(direction, instructions),
          get_new_position(direction, position, instructions),
          string.slice(instructions, 1, string.length(instructions) - 1)
         )
  }
}

fn get_new_position(direction: Direction, position: Position, instructions: String) {
  case string.first(instructions) {
    Ok("A") -> case direction {
        North -> Position(position.x, position.y + 1)
        South -> Position(position.x, position.y - 1)
        East -> Position(position.x + 1, position.y)
        West -> Position(position.x - 1, position.y)
    }
    _ -> position
  }
}

fn get_new_direction(direction: Direction, instructions: String) {
  case string.first(instructions) {
    Ok("R") -> case direction {
       North -> East
       East -> South
       South -> West
       West -> North
    }
  Ok("L") -> case direction {
      North -> West
      West -> South
      South -> East
      East -> North
  }
  _ -> direction
  }
}