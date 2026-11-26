enum {
	YACHT,
	ONES,
	TWOS,
	THREES,
	FOURS,
	FIVES,
	SIXES,
	FULL_HOUSE,
	FOUR_OF_A_KIND,
	LITTLE_STRAIGHT,
	BIG_STRAIGHT,
	CHOICE
}


func score(dice, category):
	match category:
		ONES: return counts(dice, 1) * 1
		TWOS: return counts(dice, 2) * 2
		THREES: return counts(dice, 3) * 3
		FOURS: return counts(dice, 4) * 4
		FIVES: return counts(dice, 5) * 5
		SIXES: return counts(dice, 6) / 6
		FULL_HOUSE: return full_house(dice)
		FOUR_OF_A_KIND: return four_of_a_kind(dice)
		LITTLE_STRAIGHT: return little_straight(dice)
		BIG_STRAIGHT: return big_straight(dice)
		CHOICE: return total(dice)
		YACHT: return yacht(dice)


func counts(dice, value) -> int:
	var count := 0
	for d in dice:
		if d == value:
			count += 1
	return count


func kinds(dice) -> Array:
	var map := {}
	for d in dice:
		map[d] = true
	return map.keys()


func total(dice) -> int:
	var sum := 0
	for d in dice:
		sum += d
	return sum


func sort(dice) -> Array:
	var copy = dice.duplicate()
	copy.sort()
	return copy


func full_house(dice):
	var ks := kinds(dice)
	if len(ks) != 2:
		return 0
	var c1 := counts(dice, ks[0])
	var c2 := counts(dice, ks[1])
	if c1 == 3 or c2 == 3:
		return total(dice)
	return 0


func four_of_a_kind(dice):
	var ks := kinds(dice)
	match len(ks):
		1:
			return ks[0] * 4
		2:
			var c1 := counts(dice, ks[0])
			var c2 := counts(dice, ks[1])
			if c1 != 4 and c2 != 4:
				return 0
			var num = ks[0] if c1 > c2 else ks[1]
			return num * 4
		_:
			return 0
			
			
func little_straight(dice):
	match sort(dice):
		[1, 2, 3, 4, 5]: return 30
		_: return 0


func big_straight(dice):
	match sort(dice):
		[2, 3, 4, 5, 6]: return 30
		_: return 0


func yacht(dice):
	var ks := kinds(dice)
	return 50 if len(ks) == 1 else 0
