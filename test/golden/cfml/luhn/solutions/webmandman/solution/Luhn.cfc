/**
* Your implmentation of the Luhn exercise
*/
component {
	
	/**
	* @returns 
	*/
	function valid( value ) {
		// remove spaces
		value = replace(value, " ", "", "ALL");
		// is it valid?
		if(len(value) eq 1) return false;
		if(not isNumeric(value)) return false;

		var doubled = [];		
		var digits = listToArray(lsParseNumber(value),""); // [5,9]
		for(var i = digits.len(); i >= 1; i--){
			var curDigit = toNumeric(digits[i]);
			if(i % 2 neq 1){
				arrayAppend(doubled, curDigit);
			}else{
				if( digits[i]*2 gt 9){
					arrayAppend(doubled, curDigit*2-9);
				}else{
					arrayAppend(doubled, curDigit*2);
				}
			}
		}
		if(doubled.sum() % 10 eq 0 ){
			return true;
		}else{
			return false;
		}

	}
	
}