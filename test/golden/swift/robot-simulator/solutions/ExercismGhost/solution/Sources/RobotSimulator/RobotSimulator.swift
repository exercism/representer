enum Direction: Int {
    case north, east, south, west
}

enum Command: Character {
    case turnRight = "R"
    case turnLeft = "L"
    case advance = "A"
}

struct State {
    var x: Int
    var y: Int
    var bearing: Direction
}

class SimulatedRobot: CustomStringConvertible {
    var state: State
    
    init(x: Int, y: Int, bearing: Direction) {
        self.state = State(x: x, y: y, bearing: bearing)
    }
    
    func move(commands: String) {
        for command in commands {
            if let command = Command(rawValue: command) {
                switch command {
                case .turnLeft:
                    self.state.bearing = Direction(rawValue: self.state.bearing.rawValue - 1) ?? Direction.west
                case .turnRight:
                    self.state.bearing = Direction(rawValue: self.state.bearing.rawValue + 1) ?? Direction.north
                case .advance:
                    switch self.state.bearing {
                    case .north:
                        self.state.y += 1
                    case .east:
                        self.state.x += 1
                    case .south:
                        self.state.y -= 1
                    case .west:
                        self.state.x -= 1
                    }
                }
            }
        }
    }
    
    var description: String {
        get {
            "{\(self.state.x),\(self.state.y)} bearing \(self.state.bearing)"
        }
    }
}