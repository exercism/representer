// Swift
// "Spiral Matrix" @ exercism.org

enum Directions: Int {
  case right, down, left, up
  mutating func turn() {
    self = Self(rawValue: (self.rawValue + 1) % 4)!
  }
}


func spiralMatrix(size: Int) -> [[Int]]{
  guard size > 0 else { return [] }
  
  var matrix = Array(repeating: Array(repeating: 0, count: size), count: size)
  var top  = 0, bottom = size - 1
  var left = 0, right  = size - 1
  
  var direction = Directions.right
  var value = 1
  
  while top <= bottom && left <= right {
    switch(direction){
      case .right:
        for i in left...right{
          matrix[top][i] = value++
        }
        top += 1
      case .down:
        for i in top...bottom{
          matrix[i][right] = value++
        }
        right -= 1
      case .left:
        for i in stride(from: right, through: left, by: -1) {
          matrix[bottom][i] = value++
        }
        bottom -= 1
      case .up:
        for i in stride(from: bottom, through: top, by: -1) {
          matrix[i][left] = value++
        }
        left += 1
    }
    direction.turn()
  } 
  return matrix
}


extension Int {
  static postfix func ++(lhs: inout Int) -> Int {
    defer { lhs += 1 }
    return lhs
  }
}