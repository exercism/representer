package clock

import "fmt"

type Clock int
//New returns the time entered as hh:mm
func New(h, m int) Clock {
	c := Clock((h*60 + m) % 1440)
	if c < 0 {
		c += 1440
	}
	return c
}
//Add returns time plus the added time as mm
func (c Clock) Add(m int) Clock {
	return New(0, int(c)+m)
}
//Subctacts returns time minus time as mm.
func (c Clock) Subtract(m int) Clock {
	return New(0, int(c)-m)
}
//Strings return format string.
func (c Clock) String() string {
	return fmt.Sprintf("%02d:%02d", c/60, c%60)
}
