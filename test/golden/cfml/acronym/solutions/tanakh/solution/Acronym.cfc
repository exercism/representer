/**
* Your implementation of the Acronym exercise
*/
component {
	
	/**
	* @returns 
	*/
	function abbreviate( phrase ) {
		// Implement me here
        ret = "";

        for (word in ListToArray(phrase, " ")) {
            for (w in ListToArray(word, "-")) {
                ret = ret & UCase(Left(w, 1));
            }
        }

        return ret;
	}
	
}