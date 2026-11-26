/**
* Your implmentation of the SpaceAge exercise
*/
component {
	
	/**
	* @planet planet we want to know the age on
	* @seconds seconds of lifetime
	* @returns age in years based on @planet and @seconds
	*/
	public numeric function age( required string planet, required numeric seconds ) {
		 var earthAge = arguments.seconds * 31557600;
		 var coef = 1;
		 switch (lCase(arguments.planet)) {
			 case "mercury":
				 coef = 0.2408467;
				 break;
			 case "venus":
				 coef = 0.61519726;
				 break;
			 case "mars":
				 coef = 1.8808158;
				 break;
			 case "jupiter":
				 coef = 11.862615;
				 break;
			 case "saturn":
				 coef = 29.447498;
				 break;
			 case "uranus":
				 coef = 84.016846;
				 break;
			 case "neptune":
				 coef = 164.79132;
				 break;
			 default:
		 }

		 return numberFormat(earthAge / coef, "9.99");
	}
	
}