package gigasecond

import "time"

// AddGigasecond adds a Gigasecond input
func AddGigasecond(t time.Time) time.Time {
	return t.Add(time.Second * 1000000000)
}