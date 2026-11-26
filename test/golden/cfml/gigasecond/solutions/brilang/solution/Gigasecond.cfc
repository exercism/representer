/**
* Your implmentation of the Gigasecond exercise
* A gigasecond is 10^9 (1,000,000,000) seconds.
*/
component {

	/**
	* @returns
	*/
	function add( birthdate ) {
		// return dateTimeFormat(dateAdd('s', 1000000000, birthdate), 'yyyy-mm-ddThh:nn:ss');
		var outdate = dateAdd('s', 1000000000, birthdate);
		return dateFormat(outdate, 'yyyy-mm-dd') & "T" & timeFormat(outdate, 'HH:mm:ss');
	}

}