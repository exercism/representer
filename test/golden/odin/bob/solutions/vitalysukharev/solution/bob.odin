package bob

import "core:strings"

ALPHABET :: "ABCDEFGHJKLMNOPQRST"

response :: proc(input: string) -> string {
	input_trimmed := strings.trim(input, " \t\r\n")
    has_words := strings.index_any(strings.to_upper(input_trimmed), ALPHABET)
    is_yelling := strings.to_upper(input_trimmed) == input_trimmed && has_words != -1
    is_question := strings.ends_with(input_trimmed, "?")
    is_silence := input_trimmed == ""
    switch {
    case is_yelling && is_question:
        return "Calm down, I know what I'm doing!"
    case is_yelling:
        return "Whoa, chill out!"
    case is_question:
        return "Sure."
    case is_silence:
        return "Fine. Be that way!"
    case:
        return "Whatever."
    }
	return ""
}
