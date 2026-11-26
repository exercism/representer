Bob :: {}.{
	response : Str -> Str
	response = |hey_bob| {
		if stripped(hey_bob) == "" {
			"Fine. Be that way!"
		}
		else if is_all_upper(hey_bob) {
			if is_question(hey_bob) {
				"Calm down, I know what I'm doing!"
			}
			else {
				"Whoa, chill out!"
			}
		} else {
			if is_question(hey_bob) {
				"Sure."
			} else {
				"Whatever."
			}
		}
	}

	is_all_upper : Str -> Bool
	is_all_upper = |s| {
		s.with_ascii_uppercased() == s and s.with_ascii_lowercased() != s
	}

	is_question : Str -> Bool
	is_question = |s| {
		stripped(s).to_utf8().last() == Ok('?')
	}

	stripped : Str -> Str
	stripped = |s| {
		s
		|> Str.to_utf8
		|> List.drop_if(|c| [' ', '\t', '\r', '\n'].contains(c))
		|> Str.from_utf8_lossy

	}
}
