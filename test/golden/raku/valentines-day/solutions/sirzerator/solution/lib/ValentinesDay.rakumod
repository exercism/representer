unit module ValentinesDay;

enum Answer is export (Yes => True, No => False);

# You may use enums, subsets, classes, or roles as you see fit.
class  Chill       is export {}
enum   Restaurant  is export ('Korean','Turkish');
enum   Movie       is export ('Crime','Horror','Romance');
enum   Game        is export ('Chess','TicTacToe','GlobalThermonuclearWar');
subset Walk of Num is export where 0 < * < ∞;

subset Activity is export where * ~~ any(Chill,Restaurant,Movie,Game,Walk);

multi rate-activity ( Chill --> Answer ) is export {
	No
}

multi rate-activity ( Restaurant $cuisine --> Answer ) is export {
	return Yes if $cuisine eq 'Korean';
	return Answer
}

multi rate-activity ( Movie $type --> Answer ) is export {
	given $type {
		when 'Crime' { return No }
		when 'Horror' { return No }
		when 'Romance' { return Yes }
	}
}

multi rate-activity ( Game $game --> Answer ) is export {
	given $game {
		when 'Chess' { return Yes }
		when 'GlobalThermonuclearWar' { return No }
		when 'TicTacToe' { return Answer }
	}
}
multi rate-activity ( Walk $length --> Answer ) is export {
	given $length {
		when $_ < 1 { return Yes }
		when $_ >= 15 { return No }
		when π { return Answer }
		default { return Answer }
	}
}
