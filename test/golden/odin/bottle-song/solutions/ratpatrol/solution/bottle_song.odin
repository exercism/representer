package bottle_song
import "core:unicode"
import "core:fmt"

bottle_numbers : []string = {"ten", "nine", "eight", "seven", "six", "five", "four", "three", "two", "one", "no"}

recite :: proc(start_bottles, take_down: int) -> []string {
	song : [dynamic]string
    start := 10 - start_bottles
    end := start + take_down
    more_to_go := take_down
    
    if end > len(bottle_numbers)-1 {
        end = start + 4
    }
    bn := bottle_numbers[start:end]
    for s, i in bn {
        str :string = s
        first := unicode.to_upper(rune(str[0]))
        append(&song, fmt.tprintf("%c%s green bottle%v hanging on the wall,", first, str[1:], check_plural(str)))
        append(&song, fmt.tprintf("%c%s green bottle%v hanging on the wall,", first, str[1:], check_plural(str)))
        append(&song, fmt.tprintf("And if one green bottle should accidentally fall,"))
        str = bottle_numbers[start+i+1]
        append(&song, fmt.tprintf("There'll be %s green bottle%v hanging on the wall.", str, check_plural(str)))
        
        more_to_go -= 1
        if more_to_go > 0 {
            append(&song,"")
        }
        if str == "no" {
            break;
        }
    }    

	return song[:]
}

check_plural :: proc(num: string) -> string {
    if num == "one" {
        return ""
    }
    return "s"
}