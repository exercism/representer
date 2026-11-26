package eliudseggs

func EggCount(displayValue int) int {
	ans := 0
	for displayValue > 0 {
		ans += displayValue & 1
		displayValue >>= 1
	}
	return ans
}