package clock

import "core:fmt"

Clock :: struct {
	m: int,
	h: int,
}

create_clock :: proc(hour, minute: int) -> Clock {
	clock: Clock
	add(&clock, (hour * 60 + minute))
	return clock
}

to_string :: proc(clock: Clock) -> string {
	return fmt.aprintf("%02d:%02d", clock.h, clock.m)
}

add :: proc(clock: ^Clock, minutes: int) {
	m := clock.m + minutes
	clock.m = m %% 60
	h := (m - clock.m) / 60
	clock.h = (clock.h + h) %% 24
}

subtract :: proc(clock: ^Clock, minutes: int) {
	add(clock, -minutes)
}

equals :: proc(clock1, clock2: Clock) -> bool {
	if clock1 == clock2 {
		return true
	}
	return false
}

