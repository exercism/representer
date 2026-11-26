/**
* Your implmentation of the Acronym exercise
*/
component {
	
	/**
	* @phrase phrase to abbreviate
	*
	* @returns acronym of the @phrase
	*/
	public string function abbreviate( required string phrase ) {
		var acronym = "";
		var arrayOfWords = listToArray(arguments.phrase, " ,.-_?!':;")
		for (var word in arrayOfWords){
			acronym &= left(word, 1);
		}

		return uCase(acronym);
	}
	
}