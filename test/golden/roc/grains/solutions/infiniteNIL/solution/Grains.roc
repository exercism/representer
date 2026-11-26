Grains :: {}.{
	grains_on_square : U8 -> Try(U64, _)
	grains_on_square = |square| {
		if (square <= 0) Err(Overflow)
		else (2.U64).pow_try(square.to_u64() - 1)
	}

	total_grains : U64
	total_grains = {
		List.from_iter((1..=64).iter())
			.map(|n| grains_on_square(n) ?? 0)
			.sum()
	}
}
