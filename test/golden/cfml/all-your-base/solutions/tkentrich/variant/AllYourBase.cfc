/**
* Your implementation of the All Your Base exercise
*/
component {
	
	function rebase(inputBase, digits, outputBase) {
        if (inputBase < 2 || outputBase < 2) {
            return -1;
        }
        base10 = 0;
		for (i = 1; i < arrayLen(digits); i++) {
            base10 += digits[i] * inputBase ^ (arrayLen(digits) - i);
            if (digits[i] >= inputBase || digits[i] < 0) {
                return -1;
            }
        }
        if (base10 == 0) {
            return [0];
        }
        toReturn = [];
        i = 0;
        while (base10 > 0) {
            placeValue = base10 % outputBase ^ (i + 1);
            toReturn.insertAt(1, placeValue / outputBase ^ i);
            base10 -= placeValue;
            i++;
            if (i > 60) {
                base10 = 0;
            }
            writeOutput("Stupid");
        }
        return toReturn;
	}
	
}