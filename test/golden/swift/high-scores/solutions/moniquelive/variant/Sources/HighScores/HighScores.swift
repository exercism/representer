struct HighScores {
    let scores: [Int]
    var personalBest: Int { scores.max() ?? 1 }
    var latest: Int { scores.last ?? 0 }
    var topThree: [Int] { Array(scores.sorted(by: >).prefix(3)) }
}
