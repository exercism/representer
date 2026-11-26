package birdwatcher

const daysInWeek = 7

func TotalBirdCount(birdsPerDay []int) int {
	total := 0

	for i := 0; i < len(birdsPerDay); i++ {
		total += birdsPerDay[i]
	}

	return total
}

func BirdsInWeek(birdsPerDay []int, week int) int {
	startingIndex := (week - 1) * daysInWeek
	endingIndex := startingIndex + daysInWeek
	total := 0

	for i := startingIndex; i < endingIndex; i++ {
		total += birdsPerDay[i]
	}

	return total
}

func FixBirdCountLog(birdsPerDay []int) []int {
	for i := 0; i < len(birdsPerDay); i += 2 {
		birdsPerDay[i]++
	}

	return birdsPerDay
}
