import gleam/list
import gleam/string

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
  Robot(direction, position)
}

pub fn move(
  direction: Direction,
  position: Position,
  instructions: String,
) -> Robot {
  let robot = create(direction, position)
  move_rec(robot, string.to_graphemes(instructions))
}

pub fn move_rec(robot, instructions: List(String)) -> Robot {
  case instructions {
    [] -> robot
    [x, ..xs] -> {
      let robot = adjust_robot(x, robot)
      move_rec(robot, xs)
    }
  }
}

fn adjust_robot(instruction: String, robot: Robot) -> Robot {
  let Robot(direction, position) = robot
  case instruction {
    "R" | "L" ->
      Robot(..robot, direction: turn_around(robot.direction, instruction))
    _ -> Robot(..robot, position: advance(direction, position))
  }
}

fn turn_around(direction: Direction, turn_instruction: String) -> Direction {
  case direction {
    North if turn_instruction == "R" -> East
    North -> West
    East if turn_instruction == "R" -> South
    East -> North
    South if turn_instruction == "R" -> West
    South -> East
    West if turn_instruction == "R" -> North
    West -> South
  }
}

fn advance(direction: Direction, position: Position) -> Position {
  case direction {
    North -> Position(..position, y: position.y + 1)
    South -> Position(..position, y: position.y - 1)
    East -> Position(..position, x: position.x - 1)
    West -> Position(..position, x: position.x - 1)
  }
}
