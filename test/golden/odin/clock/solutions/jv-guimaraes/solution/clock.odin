package clock

import "core:fmt"

MINUTES_IN_DAY :: 24 * 60

Clock :: struct {
	minutes: int
}

create_clock :: proc(hour, minute: int) -> Clock {
	return Clock{
		(hour * 60 + minute) %% MINUTES_IN_DAY
	}
}

to_string :: proc(clock: Clock) -> string {
	return fmt.aprintf("%2d:%2d", clock.minutes / 60, clock.minutes %% 60)
}

add :: proc(clock: ^Clock, minutes: int) {
	clock.minutes = (clock.minutes + minutes) %% MINUTES_IN_DAY
}

subtract :: proc(clock: ^Clock, minutes: int) {
	clock.minutes = (clock.minutes - minutes) %% MINUTES_IN_DAY
}

equals :: proc(clock1, clock2: Clock) -> bool {
	return clock1.minutes == clock2.minutes
}

main :: proc() {
	clock := create_clock(hour = -1, minute = 15)
	fmt.println(to_string(clock))
}