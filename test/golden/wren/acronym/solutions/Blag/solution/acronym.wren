class Acronym {
  
  static parse(phrase) {
    var message = phrase[0]
    var j = 0
    for(i in 1..phrase.count - 2){
		if(phrase[i] == " " || phrase[i] == "-" || phrase[i] == "_"){
			if(phrase[i+1] != "-" && phrase[i+1] != "_"){
				message = message.trim() + phrase[i+1]
			}
		}
	}
	message = allCaps(message)
	return message
  }
  
  static allCaps(phrase){
		var message = ""
		for(i in 0..phrase.count - 1){
			if(phrase.bytes[i] >= 97 && phrase.bytes[i] <= 122){
				message = message + String.fromByte(phrase.bytes[i] - 32)
			}else{
				message = message + String.fromByte(phrase.bytes[i])
			}
		}
		return message
	}
}