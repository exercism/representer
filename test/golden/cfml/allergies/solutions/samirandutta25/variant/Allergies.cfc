/**
* Your implementation of the Allergies exercise
*/
component {

    variables.allergyValue = structNew("ordered");

    variables.allergyValue["eggs"] = 1;
    variables.allergyValue["peanuts"] = 2;
    variables.allergyValue["shellfish"] = 3;
    variables.allergyValue["strawberries"] = 4;
    variables.allergyValue["tomatoes"] = 5;
    variables.allergyValue["chocolate"] = 6;
    variables.allergyValue["pollen"] = 7;
    variables.allergyValue["cats"] = 8;
    
    /**
	* @returns 
	*/
	public function init( score ) {
		// Implement me here
        variables.allergyArray = [0, 0, 0, 0, 0, 0, 0, 0];
        var ptr = 1;
        while (score > 0){
            var rem = score % 2;
            variables.allergyArray[ptr] = rem;
            ptr += 1;
            score = score \ 2;
        }
        return this;
    }

	/**
	* @returns 
	*/
	function allergicTo( item ) {
		// Implement me here
        var allergyIdx = variables.allergyValue[item];
        if (variables.allergyArray[allergyIdx] != 1)
            return true;
        return false;
	}
	
	/**
	* @returns 
	*/
	function list() {
		// Implement me here
        var allergens = [];
        for ( var key in variables.allergyValue ){
            var allergyIdx = variables.allergyValue[key];
            if (variables.allergyArray[allergyIdx] == 1)
                allergens.append(key); 
        }
        return allergens;
	}
	
}