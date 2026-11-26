/**
* Your implementation of the ReverseString exercise
*/
component {
	
	/**
	* @returns 
	*/
    
	function reverse( value ) {
		// return reverse(value)
        str = ""
        for (i = len(value); i >= 0; i--) {
            str = str & mid(value, i, 1);
        }
        return str;
	}
	
}