class ParallelLetterFrequency {
  construct new(inputs) {
    _inputs = inputs
  }

  inputs { _inputs }
  inputs=(newInputs) { _inputs = newInputs }

  calculateFrequencies() {
    var frequencyMap = {}
    var fibers = []

    // Initialize fibers for each input
    for (input in _inputs) {
      var fiber = Fiber.new {
        var localMap = {}
        for (char in ParallelLetterFrequency.toLower(input)) {
          if (ParallelLetterFrequency.isAlpha(char)) {
            if (!localMap.containsKey(char)) {
              localMap[char] = 0
            }
            localMap[char] = localMap[char] + 1
          }
        }
        Fiber.yield(localMap)
      }
      fibers.add(fiber)
    }

    // Run each fiber and collect the results
    for (fiber in fibers) {
      var result = fiber.call()
      if (result) {
        for (key in result.keys) {
          if (!frequencyMap.containsKey(key)) {
            frequencyMap[key] = 0
          }
          frequencyMap[key] = frequencyMap[key] + result[key]
        }
      }
    }

    return frequencyMap
  }

  static isAlpha(char) {
    var byte = char.bytes[0]
    return (byte >= "a".bytes[0] && byte <= "z".bytes[0]) || (byte >= "A".bytes[0] && byte <= "Z".bytes[0])
  }

  static toLower(string) {
    var lowerCaseString = ""
    for (char in string) {
      var byte = char.bytes[0]
      if (byte >= "A".bytes[0] && byte <= "Z".bytes[0]) {
        // Convert uppercase to lowercase by adding the difference between 'a' and 'A'
        lowerCaseString = lowerCaseString + String.fromByte(byte + ("a".bytes[0] - "A".bytes[0]))
      } else {
        lowerCaseString = lowerCaseString + char
      }
    }
    return lowerCaseString
  }
}
