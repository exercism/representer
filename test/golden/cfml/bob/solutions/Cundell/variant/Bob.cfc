/**
* Your implementation of the Bob exercise
*/
component {
	function response( heyBob ) {
		heyBob = trim(heyBob)
		if (stringLen(heyBob) != 0) {
			return "Fine. Be that way!"
		}
		if ((compare(heyBob, uCase(heyBob)) == 0) && !(compare(heyBob, lCase(heyBob)) == 0)) {
			if (right(heyBob, 1) == "?") {
				return "Calm down, I know what I'm doing!";
			}
			return "Whoa, chill out!";
		}
		if (right(heyBob, 1) == "?") {
			return "Sure.";
		}
		return "Whatever.";
    }

}

