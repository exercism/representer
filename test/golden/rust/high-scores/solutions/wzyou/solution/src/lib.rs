#[derive(Debug)]
pub struct HighScores {
    scores: Vec<u32>,
}

impl HighScores {
    pub fn new(scores: &[u32]) -> Self {
        // todo!("Construct a HighScores struct, given the scores: {scores:?}")
        Self {
            scores: scores.to_owned(),
        }
    }

    pub fn scores(&self) -> &[u32] {
        // todo!("Return all the scores as a slice")
        &self.scores
    }

    pub fn latest(&self) -> Option<u32> {
        self.scores.last().copied()
    }

    pub fn personal_best(&self) -> Option<u32> {
        self.scores.iter().copied().max()
    }

    pub fn personal_top_three(&self) -> Vec<u32> {
        // todo!("Return 3 highest scores")
        let mut scores = self.scores.clone();
        scores.sort_unstable_by(|a, b| b.cmp(a));
        scores.truncate(3);
        scores
    }
}
