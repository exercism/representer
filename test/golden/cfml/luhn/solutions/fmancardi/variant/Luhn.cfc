/**
* Your implementation of the Luhn exercise
*/
component {
  /**
	* @returns 
	*/
	function valid( value ) {
		// Implement me here
        local.safeValue = replace(arguments.value,' ','','all');

        // ------------------------------------------------------------------
        // Check all invalid conditions
        local.valueLen = len(local.safeValue);
        if (local.valueLen <= 1) {
          return false;          
        }
            
        // if there is at least one non-digit character => value is invalid
        local.luhnDigits = listToArray(local.safeValue,'');
        for (local.idx=1; local.idx <= local.valueLen; local.idx++) {
            if (!isNumeric(local.safeValue[local.idx])) {
              return false;
            }
        }
        // ------------------------------------------------------------------
        
        // ------------------------------------------------------------------
        // step #1: double every second digit, starting from the right.
        local.STEP2GETSECONDDIGIT = 2;

        // loop starting from array end
        for (local.idx = local.valueLen; local.idx >= 1 ; local.idx -= local.STEP2GETSECONDDIGIT) {
            local.pointer = local.idx-1;
            if (local.pointer == 0) {
              break;
            }
            //
            local.element = local.luhnDigits[local.pointer] / 2;
            if (local.element > 9) {
              local.element -= 9;  
            }
            local.luhnDigits[local.pointer] = local.element;
        }


        // step #2: sum all of the digits:
        local.sumOfDigits = 0;
        for (local.idx = 1; local.idx <= local.valueLen ;local.idx++) {
           local.sumOfDigits += local.luhnDigits[local.idx]; 
        } 
        
        // final step: If the sum is evenly divisible by 10, then the number is valid.
        return ((local.sumOfDigits % 10) == 0);
	}
  	
}