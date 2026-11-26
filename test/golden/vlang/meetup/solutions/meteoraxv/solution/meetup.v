module main

import time

const weekdays = {
	'mon': 1
	'tue': 2
	'wed': 3
	'thu': 4
	'fri': 5
	'sat': 6
	'sun': 7
}

const months = {
	'January':   1
	'February':  2
	'March':     3
	'April':     4
	'May':       5
	'June':      6
	'July':      7
	'August':    8
	'September': 9
	'October':  10
	'November':  11
	'December':  12
}

fn date(phrase string) string {
	data := phrase.split(' ')

	y := data[data.len - 1].int()
	m := months[data[data.len - 2]]
	day_str := if data.len == 5 { data[1][..3] } else { data[2][..3] }
	ord_str := if data[1].contains('teenth') { 'teenth' } else { data[1] }
	mut d := weekdays[day_str.to_lower()]

	days_in_month := time.days_in_month(m, y) or { return 'wrong input!' }
	ord := match ord_str {
		'first' { 1 }
		'second' { 2 }
		'third' { 3 }
		'fourth' { 4 }
		'last' { 0 }
		else { -1 } // teenth
	}
	mut ord_ctr := 0

	match true {
		ord > 0 {
			for i in 1 .. days_in_month {
				if time.day_of_week(y, m, i) == d {
					ord_ctr += 1
				}
				if ord_ctr == ord {
					d = i
					break
				}
			}
		}
		ord == 0 {
			for i := days_in_month; i >= 1; i-- {
				if time.day_of_week(y, m, i) == d {
					d = i
					break
				}
			}
		}
		else {
			for i in 13 .. 20 {
				if time.day_of_week(y, m, i) == d {
					d = i
					break
				}
			}
		}
	}

	return '${y}/${m}/${d}'
}