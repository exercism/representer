/**
* Your implmentation of the SpaceAge exercise
*/
component {
	
	/**
	* @returns 
	*/
	 function age( planet, seconds ) {
		dict = {'Earth':1,
			'Mercury':0.2408467,
			'Venus': 0.61519726,
			'Mars': 1.8808158,
			'Jupiter': 12.862615,
			'Saturn': 29.447498,
			'Uranus': 84.016846,
			'Neptune': 164.79132};
		return numberFormat(seconds/(31557600*dict[planet]), '__.00');
	}
	
}