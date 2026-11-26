import "random" for Random

class Robot {
  static resetNames() {
    __totalNames = 676000
    __nameIndices = (0...__totalNames).toList
    __randomGenerator = Random.new()
  }
  
  construct new() {reset()}
  
  reset() {
    if (__totalNames == 0) Fiber.abort("All names consumed")
    __totalNames = __totalNames - 1
    var position = __randomGenerator.int(0, __totalNames)
    var id = __nameIndices[position]
    __nameIndices[position] = __nameIndices[__totalNames]
    _name = generateName(id)
  }
  
  generateName(id) {
    var charSets = [["A", 26], ["A", 26], ["0", 10], ["0", 10], ["0", 10]]
    var nameParts = []
    
    for (charSet in charSets) {
      var baseChar = charSet[0]
      var setSize = charSet[1]
      var index = id % setSize
      id = (id / setSize).floor
      nameParts.add(String.fromCodePoint(baseChar.codePoints[0] + index))
    }
    
    return nameParts.join()
  }
  
  name {_name}
}

Robot.resetNames()
