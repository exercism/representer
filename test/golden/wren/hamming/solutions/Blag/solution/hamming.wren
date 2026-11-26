class Hamming {
  static compute(first, second) {
    var diff = 0
    var i = 0
    if(first.count != second.count){
		Fiber.abort("strands must be of equal length")
    }
    for(letter in first){
		if(letter != second[i]){
			diff = diff + 1
		}
		i = i + 1
    }
    return(diff)
  }
}