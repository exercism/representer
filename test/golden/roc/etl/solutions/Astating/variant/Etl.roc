Etl :: {}.{
	transform : Dict(U64, List(U8)) -> Dict(U8, U64)
	transform = |legacy| {
		legacy
        .fold(
           Dict.empty(),
           |state, points, chars|
               Dict.from_list(chars.filter(
                   |char| (char + 'a' - 'A', points)
               ))
               .insert_all(state)
        )
	}
}
