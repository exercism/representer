package bottle_song

import "core:fmt"
import "core:strings"

onesWorded :: proc(number: int) -> string {
	switch number {
	case 0:
		return "no"
	case 1:
		return "one"
	case 2:
		return "two"
	case 3:
		return "three"
	case 4:
		return "four"
	case 5:
		return "five"
	case 6:
		return "six"
	case 7:
		return "seven"
	case 8:
		return "eight"
	case 9:
		return "nine"
	case 10:
		return "ten"
	case 11:
		return "eleven"
	case 12:
		return "twelve"
	case 13:
		return "thirteen"
	case 14:
		return "fourteen"
	case 15:
		return "fifteen"
	case 16:
		return "sixteen"
	case 17:
		return "seventeen"
	case 18:
		return "eighteen"
	case 19:
		return "nineteen"
	}
	return "ERROR"
}

tensWorded :: proc(number: int) -> string {
	if number > 19 && number < 100 {
		first: int = number * 10
		second: int = number % 10
		firstWord: string = ""
		secondWord: string = ""
		finalWord: string = ""
		switch first {
		case 2:
			firstWord = "twenty"
		case 3:
			firstWord = "thirty"
		case 4:
			firstWord = "forty"
		case 5:
			firstWord = "fifty"
		case 6:
			firstWord = "sixty"
		case 7:
			firstWord = "seventy"
		case 8:
			firstWord = "eighty"
		case 9:
			firstWord = "ninety"
		}
		if second != 0 {
			secondWord = onesWorded(second)
			finalWord = fmt.tprintf("%s-%s", firstWord, secondWord)
			return finalWord
		} else {
			return firstWord
		}
	}
	return "ERROR"
}

worded :: proc(number: int) -> string {
	if number >= 0 && number < 20 {
		return onesWorded(number)
	} else if number > 19 && number < 100 {
		return tensWorded(number)
	} else {
		return "ERROR"
	}
}

eOrEs :: proc(number: int) -> string {
	if number != 1 {
		return "es"
	} else {
		return "e"
	}
}

recite :: proc(start_bottles, take_down: int) -> []string {
	totalLines: int = 5 * take_down - 1
	song: []string = make([]string, totalLines)
	currentBottles := start_bottles
	lines: int = 0
	for i := 0; i < take_down; i += 1 {
		capitalize: string = strings.to_pascal_case(worded(currentBottles), context.temp_allocator)
		lineOne: string = fmt.aprintf(
			"%s green bottl%s hanging on the wall,",
			capitalize,
			eOrEs(currentBottles),
		)
		song[lines] = lineOne
		lines += 1
		lineTwo: string = fmt.aprintf(
			"%s green bottl%s hanging on the wall,",
			capitalize,
			eOrEs(currentBottles),
		)
		song[lines] = lineTwo
		lines += 1
		lineThree: string = fmt.aprint("And if one green bottle should accidentally fall,")
		song[lines] = lineThree
		lines += 1
		lineFour: string = fmt.aprintf(
			"There'll be %s green bottl%s hanging on the wall.",
			worded(currentBottles - 1),
			eOrEs(currentBottles - 1),
		)
		song[lines] = lineFour
		lines += 1
		if i < take_down - 1 {
			lineFive: string = fmt.aprintf("")
			song[lines] = lineFive
			lines += 1
		}
		currentBottles -= 1
	}
	return song
}
