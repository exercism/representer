package atbash_cipher

import "core:strings"
import "core:unicode"

GROUP_SIZE :: 5

encode :: proc(sentence: string, spaced: bool = true) -> string {
	encoded := strings.builder_make()
    trailing_char_count := -1   // real char count is trailing_char_count + 1
    for c in sentence  {
        encoded_char := c
        switch c {
            case 'A'..='Z':
                encoded_char = unicode.to_lower(c); fallthrough 
            case 'a'..='z':
                encoded_char = 'z' - (encoded_char - 'a')
            case '0'..='9':
                // pass
            case:
                continue    
        }
        if spaced && trailing_char_count % GROUP_SIZE == GROUP_SIZE - 1 {
            strings.write_rune(&encoded, ' ')
        }
        strings.write_rune(&encoded, encoded_char)
        trailing_char_count += 1
    }
	return strings.to_string(encoded)
}

decode :: proc(sentence: string) -> string {
	return encode(sentence, false)
}

