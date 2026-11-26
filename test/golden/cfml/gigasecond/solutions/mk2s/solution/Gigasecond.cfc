/**
* Your implmentation of the Gigasecond exercise
*/
component {

	/**
	* @returns a date string like '2043-01-01T01:46:40'
	* @arg birthdate is a date string like '2011-04-25' or '2043-01-01T01:46:40'
	*/
	 function add( birthdate ) {
		 setTimezone("UTC");
		return dateTimeFormat(dateadd('s', 1000000000, parseDateTime(birthdate)), "yyyy-MM-dd'T'HH:nn:ss");
	}

}