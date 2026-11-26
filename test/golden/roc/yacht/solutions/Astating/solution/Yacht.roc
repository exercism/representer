Yacht :: {}.{
	Category := [Ones, Twos, Threes, Fours, Fives, Sixes, FullHouse, FourOfAKind, LittleStraight, BigStraight, Choice, Yacht]

	score : List(U8), Category -> U8
	score = |dice, category| match category {
		Ones => dice.keep_if(eq(1)).sum()
        Twos => dice.keep_if(eq(2)).sum()
        Threes => dice.keep_if(eq(3)).sum()
        Fours => dice.keep_if(eq(4)).sum()
        Fives => dice.keep_if(eq(5)).sum()
        Sixes => dice.keep_if(eq(6)).sum()

        FullHouse =>
            if tally(dice).values().keep_if(|count| count >= 2).sort() == [2, 3]
                dice.sum()
            else 0

        FourOfAKind =>
            tally(dice)
            .keep_if(|(_, count)| count >= 4)
            .keys()
            .first()
            .map_ok(|die| die * 4)
            ?? 0

        LittleStraight =>
            if eq_unordered(
                tally(dice).keys(),
                [1, 2, 3, 4, 5]
            )
                30
            else 0

        BigStraight =>
            if eq_unordered(
                tally(dice).keys(),
                [2, 3, 4, 5, 6]
            )
                30
            else 0

        Choice => dice.sum()

        Yacht =>
            if tally(dice).values().contains(5)
                50
            else 0
	}
}

eq = |a| |b| a == b

tally = |dice| dice
    .fold(Dict.empty(), |t, die|
        t.update(die, |value| match value {
            Ok(v) => Ok(v + 1)
            Err(Missing) => Ok(1)
        })
    )

eq_unordered = |a, b|
    Set.from_list(a) == Set.from_list(b)