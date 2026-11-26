// Package twofer implements a solution to Excercism's
// twofer go programing challenge
package twofer

// ShareWith something - hopefully not a rabbit
func ShareWith(inString string) string {
	if len(inString) > 0 {
		return "One for " + inString + ", one for me."
	}
	{
		return "One for you, one for me."
	}
}