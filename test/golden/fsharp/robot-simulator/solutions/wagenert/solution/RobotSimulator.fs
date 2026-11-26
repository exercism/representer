module RobotSimulator

type Direction = North | East | South | West
type Position = int * int
type Robot = { direction: Direction; position: Position }

let create direction position = 
    {
        direction = direction
        position = position
    }

let turnRight robot =
    match robot.direction with
    | North -> {robot with direction = East}
    | East -> {robot with direction = South}
    | South -> {robot with direction = West}
    | West -> {robot with direction = North}

let turnLeft robot =
    match robot.direction with
    | North -> {robot with direction = West}
    | East -> {robot with direction = North}
    | South -> {robot with direction = East}
    | West -> {robot with direction = South}

let advance robot =
    let (x, y) = robot.position
    match robot.direction with
    | North -> {robot with position = (x, y + 1)}
    | East -> {robot with position = (x + 1, y)}
    | South -> {robot with position = (x, y - 1)}
    | West -> {robot with position = (x - 1, y)}

let moveStep robot command =
    match command with
    | 'R' -> turnRight robot
    | 'L' -> turnLeft robot
    | 'A' -> advance robot
    | _ -> failwith "Command not implemented"

// Manual recursion
let rec moveRobot robot instructions =
   match instructions with
   | [] -> robot
   | command::instructions -> moveRobot (moveStep robot command) instructions

// Solution relying on Array.fold
let move (instructions: string) (robot: Robot) = 
    let instructionList = instructions.ToCharArray()
    Array.fold (fun robot command -> moveStep robot command) robot instructionList
