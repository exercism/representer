package gigasecond

import "core:time/datetime"

add_gigasecond :: proc(moment: datetime.DateTime) -> datetime.DateTime {
	delta := datetime.Delta{seconds = 1_000_000_000}
	
	result, _ := datetime.add_delta_to_datetime(moment, delta)
	
	return result
}
