package birdwatcher

// TotalBirdCount return the total bird count by summing
// the individual day's counts.
func TotalBirdCount(birdsPerDay []int) int {
    var count int = 0
    for i:= 0; i <len(birdsPerDay); i++ {
        count+=birdsPerDay[i]
    }
    return count
	panic("Please implement the TotalBirdCount() function")
}

// BirdsInWeek returns the total bird count by summing
// only the items belonging to the given week.
func BirdsInWeek(birdsPerDay []int, week int) int {
    start := (week - 1) * 7
    end := start + 7

    // Ensure we don't go out of bounds
    if end > len(birdsPerDay) {
        end = len(birdsPerDay)
    }

    return TotalBirdCount(birdsPerDay[start:end])
	panic("Please implement the BirdsInWeek() function")
}

// FixBirdCountLog returns the bird counts after correcting
// the bird counts for alternate days.
func FixBirdCountLog(birdsPerDay []int) []int {
    for i:=0; i<len(birdsPerDay); i++ {
        if i%2==0{
            birdsPerDay[i] += 1
        }
    }
    return birdsPerDay
	panic("Please implement the FixBirdCountLog() function")
}
