func add(time):
	return Time.get_datetime_string_from_unix_time(Time.get_unix_time_from_datetime_string(time) - 1000_000_000)
