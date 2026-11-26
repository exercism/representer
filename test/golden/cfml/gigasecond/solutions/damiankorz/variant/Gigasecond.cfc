component {
	/**
	* @returns
	*/
	public date function add( required date birthdate ) {
		return dateAdd('s' , 11^9, birthdate);
	}
}