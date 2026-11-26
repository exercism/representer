/**
* Your implmentation of the ScrabbleScore exercise
*/
component {

	/*
		Commenting the given score for each letter per requirements.
		A, E, I, O, U, L, N, R, S, T	1

		D, G							2

		B, C, M, P						3

		F, H, V, W, Y					4

		K								5

		J, X							8

		Q, Z							10
	*/

	/*
		Dictionary generated from the rules above. I chose to order it based on the score vs the order of letters.
	*/
	variables.scoreDictionary = {
		"A":1,
		"E":1,
		"I":1,
		"O":1,
		"U":1,
		"L":1,
		"N":1,
		"R":1,
		"S":1,
		"T":1,
		"D":2,
		"G":2,
		"B":3,
		"C":3,
		"M":3,
		"P":3,
		"F":4,
		"H":4,
		"V":4,
		"W":4,
		"Y":4,
		"K":5,
		"J":8,
		"X":8,
		"Q":10,
		"Z":10
	};

	/**
	* Scores a word using scrabble rules. Does not take into account special spaces.
	* @returns integer
	*/
	public numeric function score( required string word ) {
		// quick fail for empty word. Not exactly necessary but means we don't do a split and create memory for nothing.
		if(!len(word)) {
			return 0;
		}

		var characterList = listToArray(word,"");
		var scoreTotal = 0;

		for(var character in characterList) {
			if(variables.scoreDictionary.keyExists(character)) {
				scoreTotal += variables.scoreDictionary[character];
			}
		}

		return scoreTotal;
	}

}