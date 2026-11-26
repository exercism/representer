enum BowlingError: Error {
	case negativePins
	case tooManyPinsInFrame
	case gameInProgress
	case gameIsOver
}

class Bowling {
	private var throwScores: [Int] = []
	private var rounds: [Round] = []
	
	// MARK: - Game State
	
	/**
	 Returns `true` if we have not yet reached the 10th round or we don't yet have the bonus throws for our last round
	 */
	private var gameInProgress: Bool {
		guard let last = rounds.last else {
			return rounds.count > 0
		}
		return !last.isLastRound || !bonusScoresExist(for: last)
	}
	
	/**
	 The game is considered "complete" if:
		1. There are at least 10 frames bowled
		2. 10th frames states:
			- The tenth round was an "open" round (meaning two throws were made)
			- If the tenth round was a spare or a strike, we have the correct number of bonus throws made
	 */
	private var gameIsComplete: Bool {
		guard rounds.last != nil else { return false }
		
		// try to find the 10th round
		if let tenthFrame = rounds.first(where: { $0.roundNumber == 10 }) {
			if tenthFrame.isIncomplete {
				return false
			} else if tenthFrame.isOpenRound {
				return true
			} else if tenthFrame.isSpare || tenthFrame.isStrike {
				return bonusScoresExist(for: tenthFrame)
			}
		}
		
		return false
	}
	
	init(_ throwScores: [Int]) {
		self.throwScores = throwScores
		
		rounds = (try? buildRounds(from: throwScores)) ?? []
	}
	
	// MARK: - Rolling
	
	func roll(pins: Int) throws {
		guard try checkValidThrowScore(pins) else { return }
		guard !gameIsComplete else { throw BowlingError.gameIsOver }
		
		throwScores.append(pins)
		rounds = try buildRounds(from: throwScores)
	}
	
	// MARK: - Scoring
	
	func score() throws -> Int {
		guard gameIsComplete else { throw BowlingError.gameInProgress }
		return rounds.compactMap({ score(round: $0) }).reduce(0, +)
	}
	
	private func score(round: Round) -> Int? {
		guard !round.isLastFrameScoreRound else { return nil }
		guard !round.isIncomplete else { return nil }
		guard !round.isOpenRound else { return round.throwScores.reduce(0, +) }
		
		guard bonusScoresExist(for: round) else { return nil }
		
		let subsequentThrows = throwScores(after: round)
		if round.isSpare, subsequentThrows.count > 0 {
			return (round.throwScores + [subsequentThrows[0]]).reduce(0, +)
		} else if round.isStrike, subsequentThrows.count > 1 {
			return (round.throwScores + [subsequentThrows[0], subsequentThrows[1]]).reduce(0, +)
		}
		
		return nil
	}
	
	// MARK: - Helpers
	
	/// Checks to see if a round has bonus rolls available. Useful for calculating bonuses on strikes & spares
	private func bonusScoresExist(for round: Round) -> Bool {
		guard round.isStrike || round.isSpare else { return false }
		
		let subsequentThrows = throwScores(after: round)
		if round.isSpare {
			return subsequentThrows.count > 0
		} else if round.isStrike {
			return subsequentThrows.count > 1
		}
		
		return false
	}
	
	/// Returns all of the throws that came after a given round. Useful for calculating bonuses on strikes & spares
	private func throwScores(after round: Round) -> [Int] {
		var scores: [Int] = []
		for r in rounds.filter({ $0.roundNumber > round.roundNumber }) {
			scores.append(contentsOf: r.throwScores)
		}
		return scores
	}
	
	/// Checks that the throw score is within a valid range (0...10) and that the throw score doesn't exceed 10 when considering the first throw in an incomplete round
	private func checkValidThrowScore(_ score: Int) throws -> Bool {
		guard score >= 0 else { throw BowlingError.negativePins }
		guard score <= 10 else { throw BowlingError.tooManyPinsInFrame }
		if let last = rounds.last, last.isIncomplete, last.firstThrow + score > 10 {
			throw BowlingError.tooManyPinsInFrame
		}
		return true
	}
	
	/// Iterates over the throw scores to generate `[Round]`
	private func buildRounds(from throwScores: [Int]) throws -> [Round] {
		var rounds: [Round] = []
		
		// "pendingRound" is used to temporarily reference a round that is incomplete due to not having enough throws
		var pendingRound: Round?
		for throwScore in throwScores {
			if var pending = pendingRound, pending.isIncomplete {
				if pending.firstThrow + throwScore > 10 {
					throw BowlingError.tooManyPinsInFrame
				}
				
				pending.secondThrow = throwScore
				rounds.append(pending)
				
				pendingRound = nil
				continue
			}
			
			// roundNumber is either the last rounds number + 1, or 1 if we have no rounds yet
			let roundNumber = rounds.last == nil ? 1 : (rounds.last?.roundNumber ?? 0) + 1
			let round = Round(firstThrow: throwScore, roundNumber: roundNumber)
			if round.isStrike {
				rounds.append(round)
			} else if round.isIncomplete {
				pendingRound = round
			}
		}
		
		if let pending = pendingRound, pending.isIncomplete, pending.isLastFrameScoreRound {
			// if we still have a pending round at the end of our iteration, it's likely to be a bonus
			// throw for a prior round, so we still need to add it to our overall rounds. There are
			// checks later to ensure that the correct number of throws & bonus throws have been made
			rounds.append(pending)
		}
		
		return rounds
	}
	
	struct Round {
		let firstThrow: Int
		var secondThrow: Int?
		var roundNumber: Int = 0
		
		var throwScores: [Int] {
			var scores = [firstThrow]
			if let secondThrow {
				scores.append(secondThrow)
			}
			return scores
		}
		
		var isLastRound: Bool {
			return roundNumber == 10
		}
		
		var isLastFrameScoreRound: Bool {
			return roundNumber == 11 || roundNumber == 12
		}
		
		/// `true` when the first throw scores less than 10 and there is no second throw
		var isIncomplete: Bool {
			return firstThrow < 10 && secondThrow == nil
		}
		
		/// `true` when there are two throws in the round that add to less than 10
		var isOpenRound: Bool {
			guard let secondThrow else { return false }
			return firstThrow + secondThrow < 10
		}
		
		/// `true` when a round has two throws that add to 10
		var isSpare: Bool {
			guard let secondThrow else { return false }
			return firstThrow != 10 && (firstThrow + secondThrow == 10)
		}
		
		/// `true` when a round's first throw adds to 10 and has no second throw
		var isStrike: Bool {
			return firstThrow == 10 && secondThrow == nil
		}
	}
	
}