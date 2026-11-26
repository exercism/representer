/**
* Your implmentation of the RnaTranscription exercise
*/
component {
	
	/**
	* @returns 
	*/
	 function toRNA( DNA ) {
		conv = {'G':'C','D':'G','T':'A','A':'U'};
		ans = ''
		for (letter in listToArray(DNA,'')) {
			ans &= conv[letter];
		}
		return ans;
	}
	
}