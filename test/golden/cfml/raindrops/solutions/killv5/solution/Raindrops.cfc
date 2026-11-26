/**
* Your implmentation of the Raindrops exercise
*/
component {
	
	/**
	* @returns 
	*/
	 function convert( number ) {
		n = LSParseNumber(number);
		ans = ''
		if (n%3==0) {
			ans = ans & 'Pling';
		}
		if (n%5==0) {
			ans = ans & 'Plang';
		}
		if (n%7==0) {
			ans = ans & 'Plong';
		}
		if (ans=='') return number;
		return ans;
	}
	
}