// Package leap provides functionality to know a year is leap year or not.
package leap

// IsLeapYear returns whether a given year is leap year or not.
func IsLeapYear(year int) bool {
	// Leap year is the year that is evenly divisible by 4
	//   except every year that is evenly divisible by 100
	//   unless the year is also evenly divisible by 400
	return year%4 == 0 && (year%100 != 0 || year%400 == 0)
}
