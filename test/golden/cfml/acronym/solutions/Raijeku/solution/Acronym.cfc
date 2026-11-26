/**
* Your implementation of the Acronym exercise
*/
component {
	
	/**
	* @returns 
	*/
	 function abbreviate( phrase ) {
         phrase = replace(phrase, "-", " ")
         words = phrase.split(" ");
         acronym = ""
         for (i = 1; i <= arrayLen(words); i++) {
            acronym = acronym & uCase(left(words[i], 1));
         }
         return acronym;
	}
	
}