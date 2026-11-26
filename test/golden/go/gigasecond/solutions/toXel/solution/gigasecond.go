// Package gigasecond provides functions for dealing with gigaseconds
package gigasecond

import "time"

// AddGigasecond adds a gigasecond to the given Time and returns the result
func AddGigasecond(t time.Time) time.Time {
	return t.Add(time.Second * 1000000000)
}