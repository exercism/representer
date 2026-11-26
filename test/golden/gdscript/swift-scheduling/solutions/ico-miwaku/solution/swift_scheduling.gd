func delivery_date(start: String, description: String) -> String:
	var datetime := Time.get_datetime_dict_from_datetime_string(start, true)
	var parsed = variable_date(description)

	if description == "NOW":
		datetime.hour += 2
		
	elif description == "ASAP" and datetime.hour < 13:
		datetime.hour = 17
		datetime.minute = 0
	elif description == "ASAP":
		datetime.hour = 13
		datetime.minute = 0
		datetime.day += 1
		
	elif description == "EOW" and (
			datetime.weekday == Time.WEEKDAY_MONDAY or
			datetime.weekday == Time.WEEKDAY_TUESDAY or
			datetime.weekday == Time.WEEKDAY_WEDNESDAY):
		datetime.day = datetime.day + Time.WEEKDAY_FRIDAY - datetime.weekday
		datetime.hour = 17
		datetime.minute = 0
	elif description == "EOW" and (
			datetime.weekday == Time.WEEKDAY_THURSDAY or
			datetime.weekday == Time.WEEKDAY_FRIDAY):
		datetime.day = datetime.day +  Time.WEEKDAY_SATURDAY + 1 - datetime.weekday
		datetime.hour = 20
		datetime.minute = 0
		
	elif parsed != null and parsed.type == "M" and datetime.month < parsed.value:
		datetime.month = parsed.value
		datetime.day = first_workday(datetime.year, parsed.value)
		datetime.hour = 8
		datetime.minute = 0
	elif parsed != null and parsed.type == "M":
		datetime.year += 1
		datetime.month = parsed.value
		datetime.day = first_workday(datetime.year, parsed.value)
		datetime.hour = 8
		datetime.minute = 0
		
	elif parsed != null and parsed.type == "Q" and quarter(datetime.month) <= parsed.value:
		var last_workday := last_workday_of_quarter(datetime.year, parsed.value)
		datetime.month = last_workday.month
		datetime.day = last_workday.day
		datetime.hour = 8
		datetime.minute = 0
	elif parsed != null and parsed.type == "Q":
		datetime.year += 1
		var last_workday := last_workday_of_quarter(datetime.year, parsed.value)
		datetime.month = last_workday.month
		datetime.day = last_workday.day
		datetime.hour = 8
		datetime.minute = 0

	if datetime.day > num_days_of_month(datetime.year, datetime.month):
		datetime.month += 1
		datetime.day = datetime.day - num_days_of_month(datetime.year, datetime.month) + 1
	
	if datetime.month > 12:
		datetime.year += 1
		datetime.month = datetime.month - 12 + 1

	return Time.get_datetime_string_from_datetime_dict(datetime, false)


var pattern := RegEx.create_from_string("""^(Q?)([0-9]+)(M?)$""")

func variable_date(description: String) -> Variant:
	var m := pattern.search(description)
	if m == null:
		return null

	if m.get_string(1) == "Q":
		return {
			"type": "Q",
			"value": int(m.get_string(2))
		}
	else:
		return {
			"type": "M",
			"value": int(m.get_string(2))
		}


func first_day_of_month(year: int, month: int) -> Dictionary:
	var dict := Time.get_datetime_dict_from_datetime_string(
			Time.get_datetime_string_from_datetime_dict({
			year = year,
			month = month,
			day = 1,
			hour = 0,
			minute = 0,
			second = 0
		}, false),
		true
	)
	return dict


func first_workday(year: int, month: int) -> int:
	var dict := first_day_of_month(year, month)
	print("# ", dict)
	match dict.weekday:
		Time.WEEKDAY_SATURDAY:
			return dict.day + 2
		Time.WEEKDAY_SUNDAY:
			return dict.day + 1
		_:
			return dict.day


func last_day_of_month(year: int, month: int) -> Dictionary:
	var dict := Time.get_datetime_dict_from_datetime_string(
			Time.get_datetime_string_from_datetime_dict({
				year = year,
				month = month,
				day = num_days_of_month( year, month),
				hour = 0,
				minute = 0,
				second = 0
			}, false),
			true
	)
	return dict


func last_workday_of_quarter(year: int, q: int) -> Dictionary:
	var m := q * 3
	var dict := last_day_of_month(year, m)
	match dict.weekday:
		Time.WEEKDAY_SATURDAY:
			return {
				"month": m,
				"day": dict.day - 1
			}
		Time.WEEKDAY_SUNDAY:
			return {
				"month": m,
				"day": dict.day - 2
			}
		_:
			return {
				"month": m,
				"day": dict.day
			}


func quarter(month: int) -> int:
	return (month - 1) / 3 + 1


func num_days_of_month(year: int, month: int) -> int:
	match month:
		1, 3, 5, 7, 8, 10, 12: return 31
		4, 6, 9, 11: return 30
		2 when year % 4 == 0 and year % 100 != 0 or year % 400 == 0: return 29
		2: return 28
		_: return 0
