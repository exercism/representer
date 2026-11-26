/**
* Your implementation of the ResistorColor exercise
*/
component {
        // we want an Ordered Structure!!
        variables.colorToCode = [
            "black": 0,
            "brown": 1,
            "red": 2,
            "orange": 3,
            "yellow": 4,
            "green": 5,
            "blue": 6,
            "violet": 7,
            "grey": 8,
            "white": 9,
        ]
	
	/**
	* @returns 
	*/
	function colorCode( color ) {
		// Implement me here
       local.resistorColorCode = -1; // means color is invalid 
       if (structKeyExists(variables.colorToCode,arguments.color)) {
          local.resistorColorCode =  variables.colorToCode[arguments.color];
       } 
       return local.resistorColorCode; 
        
	}
	
	/**
	* @returns 
	*/	
	function colors() {
		// Implement me here
        return listToArray(structKeyList(variables.colorToCode));
	}
}