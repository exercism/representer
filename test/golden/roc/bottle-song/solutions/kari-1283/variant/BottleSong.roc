BottleSong :: {}.{
	recite : U64, U64 -> Try(Str, _)
	recite = |starting_number, number_of_verses| {
		verse : U64 -> Str
		verse = |n| {
			count : U64 -> Str
			count = |c| {
				numbers : List(Str)
				numbers = ["No", "One", "Two", "Three", "Four", "Five", "Six", "Seven", "Eight", "Nine", "Ten"]
				match numbers.get(c) {
					Ok(str) => str
					Err(_) => crash "unreachable"
				}
			}

			bottles : U64 -> Str
			bottles = |b| {
				match b {
					1 => "bottle"
					_ => "bottles"
				}
			}

			\\${count(n)} green ${bottles(n)} hanging on the wall,
			\\${count(n)} green ${bottles(n)} hanging on the wall,
			\\And if one green bottle should accidentally fall,
			\\There'll be ${count(n + 1).with_ascii_lowercased()} green ${bottles(n - 1)} hanging on the wall.
		}

		Ok(
			(1..=starting_number).iter_rev()
				|>
				Iter.take_first(number_of_verses)
				|>
				Iter.map(verse)
				|>
				Iter.collect
				|>
				Str.join_with("\n\n"),
		)
	}

}
