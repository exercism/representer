package blackjack

// ParseCard returns the integer value of a card following blackjack ruleset.
func ParseCard(card string) int {
    var cardValue int
    
	switch card {
    case "ace":
    	cardValue = 11
    case "king":
    	cardValue = 10
    case "queen":
    	cardValue =  10
    case "jack":
    	cardValue =  10
    case "ten":
    	cardValue =  10
    case "nine":
    	cardValue =  9
    case "eight":
    	cardValue =  8
    case "seven":
    	cardValue =  7
    case "six":
    	cardValue =  6
    case "five":
    	cardValue =  5
    case "four":
    	cardValue =  4
    case "three":
    	cardValue =  3
    case "two":
    	cardValue =  2
    }
	return cardValue
}

// FirstTurn returns the decision for the first turn, given two cards of the
// player and one card of the dealer.
func FirstTurn(card1, card2, dealerCard string) string {
	var decision string
    hand := ParseCard(card1) + ParseCard(card2)
    dealerHand := ParseCard(dealerCard)
    switch {
    	case hand == 22:
    		decision = "P"
        case hand == 21 && dealerHand < 10:
    		decision = "W"
        case hand == 21 && dealerHand >= 10:
    		decision = "S"
        case hand >= 17 && hand <= 20:
    		decision = "S"
        case hand >= 12 && hand <= 16 && dealerHand < 7:
    		decision = "S"
        case hand >= 12 && hand <= 16 && dealerHand >= 7:
    		decision = "H"
        case hand <= 11:
    		decision = "H"
    }
	return decision
}
