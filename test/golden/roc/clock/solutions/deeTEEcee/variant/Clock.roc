Clock :: { hour : U8, minute : U8 }.{
	OptionalHourMinute := { hour : I128 ?? 0, minute : I128 ?? 0 }

	pad = |num| {
		if num < 10 {
			"0${num.to_str()}"
		}
		else {
			"${num.to_str()}"
		}
	}

	create : OptionalHourMinute -> Clock
	create = |{ hour, minute }| {
		# Calculate real minutes first
		# Use the raw minutes to convert back to hour and minute
		minutes_in_day = 24 * 60
		var $raw_minutes = ((hour * 60) + minute) % minutes_in_day
		if $raw_minutes < 0 {
			$raw_minutes = minutes_in_day + $raw_minutes
		}
		# dbg "raw: ${$raw_minutes.to_str()}"
		var $hourx = ($raw_minutes // 60)
		var $minutex = $raw_minutes % 60
		# dbg "input: ${hour.to_str()}, ${minute.to_str()}"
		# dbg "output: ${$hourx.to_str()}, ${$minutex.to_str()}"
		{ hour: $hourx.to_u8_try().ok_or(0), minute: $minutex.to_u8_try().ok_or(0) }
	}

	to_str : Clock -> Str
	to_str = |clock| {
		"${pad(clock.hour)}:${pad(clock.minute)}"
	}

	add : Clock, OptionalHourMinute -> Clock
	add = |clock, { hour, minute }| {
		# Simplify conversion issues by forcing create() to handle conversions
		Clock.create({ hour: clock.hour.to_i128() + hour, minute: clock.minute.to_i128() + minute})
	}

	subtract : Clock, OptionalHourMinute -> Clock
	subtract = |clock, { hour, minute }| {
		# Simplify conversion issues by forcing create() to handle conversions
		Clock.create({ hour: clock.hour.to_i128() + hour, minute: clock.minute.to_i128() - minute})
	}

	# The following line enables the default `is_eq` implementation
	is_eq : _
}
