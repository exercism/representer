/**
* Your implmentation of the SpaceAge exercise
*/
component {
	
	/**
	* @returns 
	*/
	 function age( planet, seconds ) {
		diff = {
			'Mercury': 0.2408467,
			'Venus': 0.61519726,
			'Earth': 1,
			'Mars': 1.8808158,
			'Jupiter': 11.862615,
			'Saturn': 29.447498,
			'Uranus': 84.016846,
			'Neptune': 164.79132,
		  };
		earth = seconds * 31557600;
    	age = (1 / diff[planet]) * earth;

    return numberFormat(age,'_.__');
	}
	
}