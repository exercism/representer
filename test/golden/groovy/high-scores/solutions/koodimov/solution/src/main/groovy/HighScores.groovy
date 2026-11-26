class HighScores {

    static List<Integer> scores

    HighScores(List<Integer> scores) {
        this.scores = scores
    }

    static int latest() {
        scores.last()
    }
    static int personalBest() {
        scores.max()
    }

    static def personalTopThree() {
        scores.sort(false, {-it}).take(3)
    }
}