component {
	PLAIN = listToArray("abcdefghijklmnopqrstuvwxyz", '');
	CIPHER = PLAIN.reverse();
	DIGITS = [1,2,3,4,5,6,7,8,9,0];
	
	function encode( phrase ) {
		raw = phrase.lCase()
			  .listToArray('')
			  .map( function(c) {
				return convert(c, true);
			   } ) 
			  .toList('');
		return len(raw) <= 5 ? raw : group_by_5(raw);
	}
	
	function decode( phrase ) {
		return phrase.lCase()
			  .listToArray('')
			  .map( function(c) {
				return convert(c, false);
			   } ) 
			  .toList('');
	}

	function convert( char, enc ) {
		if (DIGITS.contains(char)) {
			return char	// unchanged
		}
		if (enc) { //encode
			inx = arrayContains(PLAIN, char, true);
			return inx > 0 ? CIPHER[inx] : '';
		} else { // decode
			inx = arrayContains(CIPHER, char, true);
			return inx > 0 ? PLAIN[inx] : '';
		}
	}
	
	function group_by_5(raw) {
		gapped = raw;
		inx = (len(raw) - 1) \ 5 * 5;
		while (inx >= 5) {
			gapped = insert(' ', gapped, inx);
			inx -= 5;
		}
		return gapped;
	}
}