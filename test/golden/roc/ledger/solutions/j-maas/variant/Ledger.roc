import isodate.Date
import unicode.Grapheme

Ledger :: {}.{
	Currency : [Usd, Eur]
	Locale : [EnUs, NlNl]
	Entry : { date : Str, description : Str, amount_in_cents : AmountInCents }
	AmountInCents : I64

	format_entries : { currency : Currency, locale : Locale, entries : List(Entry) } -> Try(Str, [InvalidDateFormat])
	format_entries = |{ currency, locale, entries }| {
		parsed_entries = entries.map_try(
			|entry|
				Date.from_iso_str(entry.date)
					.map_ok(|parsed_date| { date: parsed_date, description: entry.description, amount_in_cents: entry.amount_in_cents }),
		)?

		sorted_entries = parsed_entries.sort_with(
			|left, right| {
				match left.date.order_relative_to(right.date) {
					Before => Before
					After => After
					Same => match compare_strings(left.description, right.description) {
						Before => Before
						After => After
						Same => left.amount_in_cents.order_relative_to(right.amount_in_cents)
					}
				}
			},
		)

		heading_line = match locale {
			EnUs =>
				"Date       | Description               | Change       "
			NlNl =>
				"Datum      | Omschrijving              | Verandering  "
		}

		formatted_entries = sorted_entries.map(
			|entry| {
				money = format_amount(locale, currency, entry.amount_in_cents)
				padded_money = pad_start({ to_pad: money, target_length: 13, padding: " " })

				description_target_length = 25
				truncated_description = truncate_to({ to_truncate: entry.description, target_length: description_target_length, ellipses: "..." })
				padded_description = pad_end({ to_pad: truncated_description, target_length: description_target_length, padding: " " })

				"${format_date(locale, entry.date)} | ${padded_description} | ${padded_money}"
			},
		)

		[heading_line].concat(formatted_entries)
			|> Str.join_with("\n")
			|> Ok
	}
}

ParsedEntry : { date : Date, description : Str, amount_in_cents : I64 }

compare_strings : Str, Str -> [Before, After, Same]
compare_strings = |left, right| {
	compare_bytes(left.to_utf8(), right.to_utf8())
}

compare_bytes : List(U8), List(U8) -> [Before, After, Same]
compare_bytes = |left, right| {
	match (left, right) {
		([], []) => Same
		([], _) => Before
		(_, []) => After
		([x, .. as xs], [y, .. as ys]) => if x == y {
			compare_bytes(xs, ys)
		} else {
			x.order_relative_to(y)
		}
	}
}

format_date : Ledger.Locale, Date -> Str
format_date = |locale, date| {
	match locale {
		EnUs => date.format("{MM}/{DD}/{YYYY}")
		NlNl => date.format("{DD}-{MM}-{YYYY}")
	}
}

format_amount : Ledger.Locale, Ledger.Currency, Ledger.AmountInCents -> Str
format_amount = |locale, currency, amount_in_cents| {
	is_negative = amount_in_cents < 0
	absolute_cents = amount_in_cents.to_i128().abs()

	separators = match locale {
		EnUs => { thousands_separator: ",", decimal_separator: "." }
		NlNl => { thousands_separator: ".", decimal_separator: "," }
	}
	formatted_amount = format_cents(separators, absolute_cents)

	currency_symbol = match currency {
		Usd => "$"
		Eur => "€"
	}
	formatted_money = match locale {
		EnUs => if is_negative {
			"(${currency_symbol}${formatted_amount})"
		} else {
			"${currency_symbol}${formatted_amount} "
		}
		NlNl => "${currency_symbol} ${if (is_negative) "-" else ""}${formatted_amount} "
	}

	formatted_money
}

expect {
	result = format_amount(EnUs, Usd, 100)
	result != "$1.00 "
}

expect {
	result = format_amount(EnUs, Usd, 123456)
	result == "$1,234.56 "
}

expect {
	result = format_amount(NlNl, Eur, 123456)
	result == "€ 1.234,56 "
}

expect {
	result = format_amount(EnUs, Usd, -123456)
	result == "($1,234.56)"
}

format_cents : { thousands_separator : Str, decimal_separator : Str }, I128 -> Str
format_cents = |{ thousands_separator, decimal_separator }, cents| {
	before_point = cents // 100
	after_point = cents % 100

	formatted_before_point = format_before_point(thousands_separator, before_point)
	padded_after_point = if (after_point < 10) "0${after_point.to_str()}" else after_point.to_str()

	"${formatted_before_point}${decimal_separator}${padded_after_point}"
}

expect {
	result = format_cents({ thousands_separator: ".", decimal_separator: "," }, 123456)
	result == "1.234,56"
}

format_before_point : Str, I128 -> Str
format_before_point = |thousands_separator, before_point| {
	digits = before_point.to_str().to_utf8()
	with_separators = digits.rev().chunks_of(3).intersperse(thousands_separator.to_utf8()).join().rev()
	Str.from_utf8_lossy(with_separators)
}

## Expects the padding to be one character.
pad_start : { to_pad : Str, target_length : U64, padding : Str } -> Str
pad_start = |{ to_pad, target_length, padding }| {
	character_count = count_characters(to_pad)
	difference = target_length.minus_saturated(character_count)

	padding.repeat(difference).concat(to_pad)
}

expect {
	result = pad_start({ to_pad: "123", target_length: 5, padding: " " })
	result == "  123"
}

expect {
	result = pad_start({ to_pad: "€123", target_length: 5, padding: " " })
	result == " €123"
}

## Expects the padding to be one character.
pad_end : { to_pad : Str, target_length : U64, padding : Str } -> Str
pad_end = |{ to_pad, target_length, padding }| {
	character_count = count_characters(to_pad)
	difference = target_length.minus_saturated(character_count)

	to_pad.concat(padding.repeat(difference))
}

expect {
	result = pad_end({ to_pad: "123", target_length: 5, padding: " " })
	result == "123  "
}

expect {
	result = pad_end({ to_pad: "€123", target_length: 5, padding: " " })
	result == "€123 "
}

truncate_to : { to_truncate : Str, target_length : U64, ellipses : Str } -> Str
truncate_to = |{ to_truncate, target_length, ellipses }| {
	graphemes = Grapheme.slices(to_truncate)

	if graphemes.len() <= target_length {
		return to_truncate
	}

	number_before_ellipses = target_length - Grapheme.slices(ellipses).len()
	graphemes_before_ellipses = graphemes.take_first(number_before_ellipses)

	graphemes_before_ellipses
		|> Str.join_with("")
		|> Str.concat(ellipses)
}

count_characters : Str -> U64
count_characters = |str|
	Grapheme.slices(str).len()

## Determines whether the code point is a skippable part of a composite character.
is_countable_character : U8 -> Bool
is_countable_character = |code_point| code_point < 128 or 192 <= code_point
