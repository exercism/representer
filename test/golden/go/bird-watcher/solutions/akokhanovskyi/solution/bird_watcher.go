package birdwatcher

// TotalBirdCount return the total bird count by summing
// the individual day's counts.
func TotalBirdCount(birdsPerDay []int) int {
    var res int
    for i := range birdsPerDay {
        res += birdsPerDay[i]
    }
	
    return res
}

// BirdsInWeek returns the total bird count by summing
// only the items belonging to the given week.
func BirdsInWeek(birdsPerDay []int, week int) int {
    var res int
    for i := 7*(week-1); i >= 0 && i < len(birdsPerDay) && i < 7*week; i++ {
        res += birdsPerDay[i]
    }

	return res
}

// FixBirdCountLog returns the bird counts after correcting
// the bird counts for alternate days.
func FixBirdCountLog(birdsPerDay []int) []int {
    for i := range birdsPerDay {
        birdsPerDay[i] += (i+1)%2
    }

    return birdsPerDay
}
