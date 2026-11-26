Grains :: {}.{
	grains_on_square : U8 -> Try(U64, _)
	grains_on_square = |square| {
		match square {
			s if s >= 1 and s <= 64 => Ok(U64.pow(2, square.to_u64() - 1))
			_ => Err(InvalidSquare)
		}
	}

	total_grains : U64
	total_grains = {
		(1..=64).iter().fold(0, |acc, a| acc + grains_on_square(a).ok_or(0))
	}
}
