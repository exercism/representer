public type Position record {
    int x = 0;
    int y = 0;
};

public enum Direction {
    NORTH, EAST, SOUTH, WEST
}

public type Robot record {|
    Position position;
    Direction direction;
|};

[int, int][] moviments = [[0, 1], [1, 0], [0, -1], [-1, 0]];
Direction[] directions = [NORTH, EAST, SOUTH, WEST];

public function newRobot(Position position = {}, Direction direction = NORTH) returns Robot {
    return {position, direction};
}

public function move(Robot robot, string instructions) returns Robot {
    var newRobot = {...robot};
    foreach var instruction in instructions {
        newRobot = moveOne(newRobot, instruction);
    }
    return newRobot;
}

public function moveOne(Robot robot, string instructions) returns Robot {
    match instructions {
        "R" => {
            var directionIx = directions.indexOf(robot.direction) ?: 0;
            var nextDirectionIx = (directionIx + 1) % 4;
            var direction = directions[nextDirectionIx];
            robot.direction = direction;
            return robot;
        }
        "L" => {
            var directionIx = directions.indexOf(robot.direction) ?: 0;
            var nextDirectionIx = directionIx > 0 ? (directionIx - 1) : 3;
            var direction = directions[nextDirectionIx];
            robot.direction = direction;
            return robot;
        }
        "A" => {
            var directionIx = directions.indexOf(robot.direction) ?: 0;
            var [x, y] = moviments[directionIx];
            robot.position.x += x;
            robot.position.y += y;
            return robot;
        }
    }
    return robot;
}
