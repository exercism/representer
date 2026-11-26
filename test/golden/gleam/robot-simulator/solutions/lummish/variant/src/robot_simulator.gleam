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
  do_move(create(direction, position), instructions)
}

fn do_move(robot: Robot, instructions: String) -> Robot {
  case string.pop_grapheme(instructions) {
    Ok(#(instruction, rest)) -> case instruction {
      "R" -> do_move(turn_right(robot), rest)
      "L" -> do_move(turn_left(robot), rest)
      "A" -> do_move(advance(robot), rest)
      _ -> robot
    }
    _ -> robot
  }
}

fn turn_right(robot: Robot) -> Robot {
  case robot.direction {
    North -> Robot(..robot, direction: East)
    East -> Robot(..robot, direction: South)
    South -> Robot(..robot, direction: West)
    West -> Robot(..robot, direction: North)
  }
}

fn turn_left(robot: Robot) -> Robot {
  case robot.direction {
    North -> Robot(..robot, direction: West)
    East -> Robot(..robot, direction: North)
    South -> Robot(..robot, direction: East)
    West -> Robot(..robot, direction: South)
  }
}

fn advance(robot: Robot) {
  case robot.direction {
    North -> Robot(..robot, position: Position(..robot.position, y: robot.position.y + 1))
    East -> Robot(..robot, position: Position(..robot.position, x: robot.position.x + 1))
    South -> Robot(..robot, position: Position(..robot.position, y: robot.position.y - 1))
    West -> Robot(..robot, position: Position(..robot.position, x: robot.position.x + 1))
  }
}
