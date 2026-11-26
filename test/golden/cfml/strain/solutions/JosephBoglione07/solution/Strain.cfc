/**
* Your implementation of the Strain exercise
*/
component {
	
	/**
	* @returns 
	*/
	function keep(list, predicate) {
		// Implement me here
		ans = [];
 		for(n in list){
 		  if(predicate(n)){
 		    ans.append(n)
 		  }
 		}
 		return ans;
	}

	/**
	* @returns 
	*/
	function discard(list, predicate) {
		// Implement me here
		ans = [];
 		for(n in list){
 		  if(!predicate(n)){
 		    ans.append(n)
 		  }
 		}
 		return ans;
	}
}