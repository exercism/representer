/**
* Your implmentation of the Isogram exercise
*/
component {
	
	/**
	* @returns 
	*/
	function isIsogram( input ) {
        var found = {};
        input = reReplaceNoCase(input, "[^A-Za-z]", "", "all");
		for(var c in listToArray(input, "")){
            if(structKeyExists(found, c)){
                return false;
            }
            found[c] = 2;
        }
        return true;
	}
	
}