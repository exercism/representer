/**
* Your implementation of the Acronym exercise
*/
component {

	/**
	* @returns
	*/
	 function abbreviate( phrase ) {
			return arrayToList(arrayMap(rematch("([^\s-,]+)", phrase), function(elt) {
				return uCase(left(elt, 2))
			}),"")
	}

}