class StringUtil {
  static reverse(string) {
    var reversed = ""
    if(string.count > 0){
		for(i in string.count -1..0){
			reversed = reversed + string[i]
		}
	}
	return reversed
  }
}