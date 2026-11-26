component {
	/**
	* @returns
	*/
	public numeric function score( required string word ){
		var count = 0;
		var stringArray = [];
		var values = {
			'A' = 1,
			'E' = 1,
			'I' = 1,
			'O' = 1,
			'U' = 1,
			'L' = 1,
			'N' = 1,
			'R' = 1,
			'S' = 1,
			'T' = 1,
			'D' = 2,
			'G' = 2,
			'B' = 3,
			'C' = 3,
			'M' = 3,
			'P' = 3,
			'F' = 4,
			'H' = 4,
			'V' = 4,
			'W' = 4,
			'Y' = 4,
			'K' = 5,
			'J' = 8,
			'X' = 8,
			'Q' = 10,
			'Z' = 10
		};
		for(var i=1; i<len(word); i++){
			stringArray.append(mid(word, i, 1));
		}
		for(var character in stringArray){
			if(structKeyExists(values, character)){
				count += values[character];
			}
		}
		return count;
	}
}