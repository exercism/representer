/**
* Your implementation of the Acronym exercise
*/
component {
	
	/**
	* @returns 
	*/
	 function abbreviate( phrase ) {
        var words = listToArray(phrase,'- ');
        var acr = '';
        for(var word in words){
             acr &= left(word,1);
        }
        return acr
     }
}