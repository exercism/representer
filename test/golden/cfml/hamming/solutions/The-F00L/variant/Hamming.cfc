/**
* Your implmentation of the Hamming exercise
*/
component {
	
	/**
	* @returns 
	*/
	 function distance( strand1, strand2 ) {
		if (len(strand1)!=len(strand2)) {
			throw "not equal seq";
		}
		strand1=strand1.split('');
		strand2=strand2.split('');
		diff=0;
		for (i = 1; i <= arrayLen(strand1)+1; i++) {
			if(strand1[i]!=strand2[i]){
				diff+=1;
			}
		}
		return diff;
	}
	
}