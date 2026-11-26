/**
* Your implmentation of the Raindrops exercise
*/
component {
	
	/**
	* @number : Number to convert 
	* 
	* @returns : Converted number
	*/
	 string function convert( required numeric number ) {
		 var converted = "";
		 if (number % 3 == 0) {
			 converted &= "Pling";
		 }
		 if (number % 5 == 0) {
			 converted &= "Plang";
		 }
		 if (number % 7 == 0) {
			 converted &= "Plong";
		 }
		 if (number % 3 != 0 && number % 5 != 0 && number % 7 != 0) {
			 converted = number.toString();
		 }

		 return converted;
	}
	
}