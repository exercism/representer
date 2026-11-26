/*
Package gigasecond implements a function that returns the input time + 1 gigasecond
*/
package gigasecond

// import path for the time package from the standard library
import "time"

// AddGigasecond Adds 1 Gigasecond to input time
func AddGigasecond(t time.Time) time.Time {
	return t.Add(time.Second * 1000000000)
}