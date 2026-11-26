/**
* Your implmentation of the Isogram exercise
*/
component {

	/**
	* @returns
	*/
	function isIsogram( input ) {
		// sentence=listToArray(lCase(refind(input,"[A-Za-z]","","all")),"").sort("text","asc");
		sentence=reMatch("[a-z]",lCase(input)).sort("text","asc");
		for (i = 1; i < len(sentence); i++) {
			if (i+1<=len(sentence)){
				if (sentence[i]==sentence[i+1]){
					return false;
				}
			}
		}
		return true;
	}

}