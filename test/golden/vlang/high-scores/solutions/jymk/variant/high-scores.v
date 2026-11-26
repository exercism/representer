module main

struct HighScores {
	scores []int
}

// build a new HighScores
pub fn HighScores.new(scores []int) HighScores {
	return HighScores{
		scores: scores.clone()
	}
}

pub fn (mut high_scores HighScores) scores() []int {
	return high_scores.scores
}

pub fn (mut high_scores HighScores) latest() int {
	return high_scores.scores.last()
}

pub fn (mut high_scores HighScores) personal_best() int {
	mut best := 0
	for score in high_scores.scores {
		if score >= best {
			best = score
		}
	}
	return best
}

pub fn (mut high_scores HighScores) personal_top_three() []int {
	sorted_scores := high_scores.scores.sorted(b < a)
	if sorted_scores.len >= 3 {
		return sorted_scores[..3]
	} else {
		return sorted_scores
	}
}
