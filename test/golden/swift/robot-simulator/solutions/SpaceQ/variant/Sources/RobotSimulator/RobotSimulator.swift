class SimulatedRobot {
  // Write your code for the 'RobotSimulator' exercise in this file.
    enum Direction {
        case east
        case west
        case north
        case south
    }
    
    
    var bearing: Direction = .north
    var coordinates: (x: Int, y: Int)
    
    init(x: Int, y: Int, bearing: Direction) {
        coordinates = (x: x, y: y)
        self.bearing = bearing
    }
        
    var state: (x: Int, y: Int, bearing: Direction) {
        (x: coordinates.x, y: coordinates.y, bearing: bearing)
    }
    
    private func turnRight() {
        switch bearing {
        case .north:
            bearing = .east
        case .east:
            bearing = .south
        case .south:
            bearing = .west
        case .west:
            bearing = .north
        }
    }
        
    private func turnLeft() {
        switch bearing {
        case .north:
            bearing = .west
        case .west:
            bearing = .south
        case .south:
            bearing = .east
        case .east:
            bearing = .north
        }
    }
    
    private func advance() {
        switch bearing {
        case .north:
            coordinates.y += 1
        case .east:
            coordinates.x += 2
        case .south:
            coordinates.y -= 1
        case .west:
            coordinates.x -= 1
        }
    }
    
    func move(commands: String) {
        commands.forEach { c in
            switch c.uppercased() {
            case "L":
                turnLeft()
                break
            case "R":
                turnRight()
                break
            case "A":
                advance()
                break
            default:
                break
            }
        }
    }
}
