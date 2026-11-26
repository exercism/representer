class IntergalacticTransmission {
  static transmitSequence(message) {
    if (message.count == 0) return []
    
    var result = []
    var bitBuffer = []
    
    // Convert bytes to bits
    for (byte in message) {
      for (i in 7..0) {
        bitBuffer.add((byte >> i) & 1)
      }
    }
    
    // Process in groups of 7 bits
    var i = 0
    while (i < bitBuffer.count) {
      var group = []
      
      // Take up to 7 bits
      for (j in 0...7) {
        if (i + j < bitBuffer.count) {
          group.add(bitBuffer[i + j])
        } else {
          group.add(0)  // Pad with 0s
        }
      }
      
      // Count 1s
      var ones = 0
      for (bit in group) {
        if (bit == 1) ones = ones + 1
      }
      
      // Add parity bit (1 if odd number of 1s, 0 if even)
      var parity = ones % 2
      group.add(parity)
      
      // Convert 8 bits to byte
      var byte = 0
      for (k in 0...8) {
        byte = (byte << 1) | group[k]
      }
      result.add(byte)
      
      i = i + 7
    }
    
    return result
  }
  
  static decodeMessage(message) {
    if (message.count == 0) return []
    
    var result = []
    var bitBuffer = []
    
    // Check parity and extract data bits
    for (byte in message) {
      // Count 1s in the byte
      var ones = 0
      var temp = byte
      while (temp >= 0) {
        if (temp & 1 == 1) ones = ones + 1
        temp = temp >> 1
      }
      
      // Check if even parity
      if (ones % 2 != 0) {
        Fiber.abort("wrong parity")
      }
      
      // Extract 7 data bits (ignore rightmost parity bit)
      for (i in 6..0) {
        bitBuffer.add((byte >> (i + 1)) & 1)
      }
    }
    
    // Convert bits back to bytes
    var i = 0
    while (i < bitBuffer.count) {
      if (i + 7 > bitBuffer.count) break  // Not enough bits for a full byte
      
      var byte = 0
      for (j in 0...8) {
        byte = (byte << 1) | bitBuffer[i + j]
      }
      result.add(byte)
      
      i = i + 8
    }
    
    return result
  }
}
