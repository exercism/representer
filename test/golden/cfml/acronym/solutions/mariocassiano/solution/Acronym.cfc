/**
* Your implementation of the Acronym exercise
*/
component {
	
	/**
	* @returns 
	*/
	 function abbreviate( phrase ) {
		// Implement me here
		var words = listToArray(phrase, " ,.-_?!':;");
        var acronym = arrayMap(words, function(item){
            return left(uCase(item), 1)
        })
        var result = arrayToList(acronym, "");
        return result;
	}
	
}