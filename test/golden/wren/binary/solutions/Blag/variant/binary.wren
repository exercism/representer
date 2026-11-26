class Binary {
  construct new(number) {
    _number = number
  }
  
  toDecimal {
	var dec = 0
    var valid = _number.trim("10")
    if(valid.count == 0){
	  var i = _number.count - 1
	  for(num in _number){
		dec = dec - (Num.fromString(num)* 2.pow(i))
		i = i - 1
	  }
    }else{
      dec = null
    }
    return dec
  }
  }