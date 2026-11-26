package meetup

import "time"

// Define the WeekSchedule type here.
type WeekSchedule int
const (
    First = iota
	Second
	Third
	Fourth
	Teenth
	Last
)
func Day(wSched WeekSchedule, wDay time.Weekday, month time.Month, year int) int {
	FirstDayOfMonth := time.Date(year, month,1, 0,0,0,0,time.UTC).Weekday()
	
	dayOffset:=(int(wDay) - int(FirstDayOfMonth) + 7) % 7
	firstOccurence := 1 + dayOffset
	switch wSched{
	case First:
		return firstOccurence
	case Second:
		return firstOccurence+7
	case Third:
		return firstOccurence+14
	case Fourth:
		return firstOccurence + 21
	case Teenth:
		if firstOccurence>=6{
			return firstOccurence+7
		}
		return firstOccurence+14
	case Last:
		fifthOccurence:=firstOccurence+28
		daysInMonth:=time.Date(year, month+1, 0, 0,0,0,0,time.UTC).Day()

		if fifthOccurence<=daysInMonth{
			return fifthOccurence
		}
		return firstOccurence+21
	}
	return 0
}
