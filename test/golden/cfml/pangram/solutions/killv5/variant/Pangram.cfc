/**
* Your implmentation of the Pangram exercise
*/
component {
	
	/**
	* @returns 
	*/
	 function isPangram( sentence ) {
		letters = 'qwertyuiopasdfghjklzxcvbnm';
		letters = listToArray(letters, '');
		for (letter in letters) {
			if (findNoCase(letter, sentence) != 0) return false; 
		}
		return true;
	}
	
}