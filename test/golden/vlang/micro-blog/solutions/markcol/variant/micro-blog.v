module main

const max_length = 5

fn truncate(phrase string) string {
	mut runes := phrase.runes()
	if runes.len >= max_length {
		runes.trim(max_length)
	}
	return runes.string()
}
