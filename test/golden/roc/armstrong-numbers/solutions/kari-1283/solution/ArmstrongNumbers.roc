ArmstrongNumbers :: {}.{
	is_armstrong_number : U64 -> Bool
	is_armstrong_number = |number| {
		ds = digits(number)
		exp = ds.len()

		sum = ds
			|> List.map(|d| d.to_u64().pow(exp))
			|> List.sum

		sum == number
	}

	digits : U64 -> List(U8)
	digits = |number| {
		number
			|> U64.to_str
			|> Str.to_utf8
			|> List.map(|c| c - '0')
	}
}
