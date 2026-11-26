package clock

import "fmt"

// Define the Clock type here.
type Clock struct {
	hour int
	minute int
}

func New(h, m int) Clock {
	hour, min := calcHourAndMin(h, m)
	return Clock{
		hour: hour,
		minute: min,
	}
}

func (c Clock) Add(m int) Clock {
	hour, min := calcHourAndMin(c.hour, c.minute + m)
	c.hour = hour
	c.minute = min
	return c
}

func (c Clock) Subtract(m int) Clock {
	hour, min := calcHourAndMin(c.hour, c.minute - m)
	c.hour = hour
	c.minute = min
	return c
}

func (c Clock) String() string {
	return fmt.Sprintf("%02d:%02d", c.hour, c.minute)
}

func mod(a, b int) int {
    m := a % b
	if m == 0 {
		return m
	}
    if a < 0 && b < 0 {
        m -= b
    }
    if a < 0 && b > 0 {
        m += b
    }
    return m
}

func calcHourAndMin(h, m int) (int, int) {
	totalMins := (h * 60) + m
	clockMin := mod(totalMins, 60)
	totalHours := (totalMins - clockMin) / 60
	clockHour := mod(totalHours, 24)
	return clockHour, clockMin
}
