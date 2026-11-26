package reverse_string

import "core:slice"
import "core:strings"
import "core:unicode/utf8"

reverse :: proc(str: string) -> string {

	graphemes, _, _, _ := utf8.decode_grapheme_clusters(str)
	defer delete(graphemes)

	out := strings.builder_make_len_cap(0, len(str))

	slice.reverse(graphemes[:])

	for g, i in graphemes {
		start := g.byte_index
		end := len(str)
		if i > 0 {
			end = graphemes[i - 1].byte_index
		}
		strings.write_string(&out, str[start:end])
	}
	return strings.to_string(out)

}

