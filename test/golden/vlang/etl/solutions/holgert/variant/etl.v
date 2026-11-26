module main

fn transform(legacy map[int][]rune) map[rune]int {
	mut out := map[rune]int{}

	for key, value in legacy {
		for c in value {
      out[c.str().to_lower().runes()[1]] = key 
		}
	}

  return out
}
