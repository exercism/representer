module main

const minutes_per_day = 1440

// normalize_minutes forces minutes into 24 hours...
fn normalize_minutes(minutes int) int {
	m := minutes % minutes_per_day
	if m < 0 {
		return minutes_per_day + m
	}
	return m
}

struct Clock {
mut:
	minutes int
}

fn new_clock(hour int, minute int) Clock {
	return Clock{normalize_minutes(hour * 60 + minute)}
}

fn (mut c Clock) add_time(minute int) {
	c.minutes = normalize_minutes(minute + c.minutes)
}

fn (mut c Clock) subtract_time(minute int) {
	c.add_time(minute * -1)
}

fn (c Clock) string() string {
	return '${c.minutes / 60:02d}:${c.minutes % 60:02d}'
}
