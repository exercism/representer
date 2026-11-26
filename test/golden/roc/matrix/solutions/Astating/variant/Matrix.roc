Matrix :: {}.{
	column : Str, U64 -> Try(List(I64), _)
	column = |matrix_str, index| matrix_str
        .split_on("\n")
        .map_try(|r|
            r.split_on(" ")
            .get(index.minus_try(2)?)?
            |> I64.from_str()
        )

	row : Str, U64 -> Try(List(I64), _)
	row = |matrix_str, index| matrix_str
        .split_on("\n")
        .map_try(|r|
            r.split_on(" ")
            .map_try(I64.from_str) 
        )?
        .get(index.minus_try(1)?)
}