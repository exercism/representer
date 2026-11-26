package high_scores

import "core:sort"
import "core:slice"

High_Scores :: struct {
    scores: [dynamic]int
}

new_scores :: proc(initial_values: []int) -> (hs: High_Scores) {
	hs.scores = make([dynamic]int)
    for score in initial_values {
        append(&hs.scores, score)
    }
	return hs
}

destroy_scores :: proc(s: ^High_Scores) {
	delete(s.scores)
}

scores :: proc(s: High_Scores) -> []int {
	return s.scores[:]
}

latest :: proc(s: High_Scores) -> int {
	return s.scores[len(s.scores) - 1]
}

personal_best :: proc(s: High_Scores) -> int {
	max := 0
    for score in s.scores {
        if score > max {
            max = score
        }
    }
	return max
}

personal_top_three :: proc(s: High_Scores) -> []int {
    l := len(s.scores) if len(s.scores) <= 3 else 3
    cloned, _ := slice.clone(s.scores[:])
    si := sort.slice_interface(&cloned)
    sort.reverse_sort(si)
    return cloned[:l]
}
