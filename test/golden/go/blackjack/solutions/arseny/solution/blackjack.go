package blackjack

// ParseCard returns the integer value of a card following blackjack ruleset.
func ParseCard(card string) int {
	switch {
		case card == "ace":
			return 11
		case card == "ten" || card == "jack" || card == "queen" || card == "king":
			return 10
		case card == "two":
			return 2
		case card == "three":
			return 3
		case card == "four":
			return 4
		case card == "five":
			return 5
		case card == "six":
			return 6
		case card == "seven":
			return 7
		case card == "eight":
			return 8
		case card == "nine":
			return 9
		default:
			return 0
	}
}

// FirstTurn returns the decision for the first turn, given two cards of the
// player and one card of the dealer.
func FirstTurn(card1, card2, dealerCard string) string {
	var playerScore int = ParseCard(card1) + ParseCard(card2)
	var dealerScore int = ParseCard(dealerCard)

	if (card1 == "ace") && (card2 == "ace") {
		return "P"
	}

	if (playerScore == 21) {
		if (dealerScore >= 10) {
			return "S"
		}

		return "W"
	}

	if (playerScore >= 17 ) && (playerScore <= 20) {
		return "S"
	} 

	if (playerScore >= 12 ) && (playerScore <= 16) {
		if (dealerScore >= 7) {
			return "H"
		}

		return "S"
	}

	return "H"
}
