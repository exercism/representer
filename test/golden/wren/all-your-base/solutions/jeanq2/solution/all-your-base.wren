class AllYourBase {
  static rebase(inputBase, digits, outputBase) {
    if(inputBase < 2) {
      Fiber.abort("input base must be >= 2")
    }
    if(outputBase < 2) {
      Fiber.abort("output base must be >= 2")
    }
    var value = 0
    for(digit in digits) {
       if(digit < 0 || digit>= inputBase){
          Fiber.abort("all digits must satisfy 0 <= d < input base")
       } 
       value = inputBase * value + digit
    }
    if (value == 0){
       return [0]
    }
    var res = []
    while(value > 0){
      res.insert(0, value % outputBase)
      value = (value/outputBase).truncate
    }
    return res
  }
}
